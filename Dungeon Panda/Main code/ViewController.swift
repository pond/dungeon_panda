//
//  ViewController.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import UIKit
import MediaPlayer
import MusicKit
import CoreAudio
import OSLog

// Hold a weak reference to the active ViewController (for Mac Catalyst builds)
private weak var macCatalystVolumeCallbackViewController: ViewController?

class ViewController: UIViewController, MusicPlaybackManagerDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playlistAndTrackName: UILabel!
    @IBOutlet weak var playPosition: UILabel!
    @IBOutlet weak var positionSlider: UISlider!
    @IBOutlet weak var volumeParentView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!

    let logger      = Logger()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var volumeView: MPVolumeView?
    var labelTimer: Timer?
    var ignorePositionUpdates: Bool = false
    var currentArtworkImage: UIImage? = nil
    var previousSystemVolume: Float32 = 0 // For Mac Catalyst builds only

    // MARK: - VIEW LIFECYCLE

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Add the volume view.
        //
        // When placed to match bounds exactly, the view is actually displaced
        // some distance vertically above the requested region, actually
        // spilling out if its container. Sigh.
        //
        let bounds = CGRect(
            x: 0,
            y: 7,
            width: self.volumeParentView.bounds.width,
            height: self.volumeParentView.bounds.height
        )

        self.volumeView = MPVolumeView(frame: bounds)
        self.volumeParentView.addSubview(self.volumeView!)

        self.volumeView!.setVolumeThumbImage(UIImage(named: "Volume slider"), for: .normal)
        self.positionSlider.setThumbImage(UIImage(named: "Position slider"), for: .normal)

        // Obtain the storyboard ID set up via selecting the Storyboard and
        // then the ViewController entry in its tree of resources, then using
        // the properties inspector to set "Storyboard ID".
        //
        // This will be "valhalla" or "main".
        //
        // See SceneDelegate for where we check which storyboard to show at
        // launch in the first place, based on whatever last-played playlist
        // was in use (if any).
        //
        let viewControllerStoryboardIdentifier = value(forKey: "storyboardIdentifier") as? String ?? "none"
        self.appDelegate.musicPlaybackManager!.storyboardIdentifierHasBecome(identifier: viewControllerStoryboardIdentifier)

        // Obtain Apple Music authorisation if need be.
        //
        if self.appDelegate.musicAuthorizationStatus == nil
        {
            self.appDelegate.musicAuthorizationStatus = MusicAuthorization.currentStatus
            
            if self.appDelegate.musicAuthorizationStatus == .notDetermined
            {
                Task {
                    self.appDelegate.musicAuthorizationStatus = await MusicAuthorization.request()
                }
            }

            switch self.appDelegate.musicAuthorizationStatus
            {
                case .authorized, .restricted:
                    logger.notice("ViewController.viewDidLoad: User authorized access to Apple Music")
                    musicAuthorizationIsGranted()
                
                case .denied:
                    logger.notice("ViewController.viewDidLoad: User prohibited access to Apple Music")
                    musicAuthorizationIsDenied()

                default:
                    logger.notice("ViewController.viewDidLoad: Unrecognised response! Assuming authorised...")
            }
        }
        else
        {
            logger.notice("ViewController.viewDidLoad: Apple Music authorization has already been checked")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.playlistAndTrackName.text = "Not playing"
        self.playPosition.text = "…"
        self.positionSlider.setValue(0, animated: false)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        self.appDelegate.musicPlaybackManager!.delegates.append(self)

        // Hackery mechanism to observe volume changes. KVO is also possible -
        // see MusicPlaybackManager's ensureVolumeObserverIsPresent - but when
        // the application has been in the background "for a while", iOS stops
        // apparently calling those observers and I haven't been able to find
        // a way to stop that.
        //
        // https://stackoverflow.com/a/59720724
        //
        // Since in iOS 17 the notification fires randomly at any old time,
        // regardless of whether the user changed volume, things get pretty
        // wild. Switchable behaviour for least-worst option via AppDelegate.
        //
        // NOTE: On Mac Catalyst, the mechanism is completely different and
        //       fairly old-fashioned / under-documented, using CoreAudio and
        //       C-like interfaces.
        //
        if self.appDelegate.useSystemVolumeNotificationsInsteadOfKvo == true
        {
            #if targetEnvironment(macCatalyst)
                macCatalystVolumeCallbackViewController = self

                var size                       = UInt32(MemoryLayout<AudioDeviceID>.size)
                var defaultAudioOutputDeviceID = kAudioObjectUnknown as AudioDeviceID
                var deviceAddress              = AudioObjectPropertyAddress(
                    mSelector: kAudioHardwarePropertyDefaultOutputDevice,
                    mScope:    kAudioObjectPropertyScopeGlobal,
                    mElement:  kAudioObjectPropertyElementMain
                )

                AudioObjectGetPropertyData(
                    AudioObjectID(kAudioObjectSystemObject),
                    &deviceAddress,
                    0,
                    nil,
                    &size,
                    &defaultAudioOutputDeviceID
                )

                var volumeAddress = AudioObjectPropertyAddress(
                    mSelector: kAudioDevicePropertyVolumeScalar,
                    mScope:    kAudioObjectPropertyScopeOutput,
                    mElement:  kAudioObjectPropertyElementMain
                )

                // Add property listener with static function pointer instead of
                // closure to avoid capture issues
                //
                AudioObjectAddPropertyListener(
                    defaultAudioOutputDeviceID,
                    &volumeAddress,
                    ViewController.macCatalystAudioVolumeChangedCBPointer,
                    nil
                )
            #else
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handleVolumeChangedNotification(_:)),
                    name: NSNotification.Name(rawValue: volumeChangedNotificationName()),
                    object: nil
                )
            #endif
        }

        let hiddenSystemVolumeSlider = self.volumeView!.subviews.first(where: { $0 is UISlider }) as? UISlider
        logger.notice("Volume slider is \(String(describing: hiddenSystemVolumeSlider))")

        self.appDelegate.musicPlaybackManager!.setHiddenSystemVolumeSlider(hiddenSystemVolumeSlider)
        self.appDelegate.musicPlaybackManager!.deduceApproximateSystemVolumeFromSliderIgnoringZero()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        // ...then *after* this transition has completed...
        //
        //   https://stackoverflow.com/a/26944087
        //
        coordinator.animate(alongsideTransition: nil) { _ in

            var targetAlpha: CGFloat = 1.0

            if self.albumArtImageView.bounds.size.width  < 200 ||
               self.albumArtImageView.bounds.size.height < 200
            {
                targetAlpha = 0.0
            }

            UIView.transition(
                with: self.playlistAndTrackName,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self!.albumArtImageView.alpha = targetAlpha
                },
                completion: nil
            )
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.appDelegate.musicPlaybackManager!.delegates.removeAll(where: { $0 as! ViewController == self })

        UIApplication.shared.endReceivingRemoteControlEvents()
        NotificationCenter.default.removeObserver(self)

        super.viewDidDisappear(animated)
    }

    // MARK: - OBSERVERS AND NOTIFICATION HANDLERS

    func volumeChangedNotificationName() -> String
    {
        if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 15, minorVersion: 0, patchVersion: 0))
        {
            return "SystemVolumeDidChange"
        }
        else
        {
            return "AVSystemController_SystemVolumeDidChangeNotification"
        }
    }

    func volumeChangedNotificationDictionaryKey() -> String
    {
        if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 15, minorVersion: 0, patchVersion: 0))
        {
            return "Volume"
        }
        else
        {
            return "AVSystemController_AudioVolumeNotificationParameter"
        }
    }

    @objc func handleVolumeChangedNotification(_ notification: NSNotification)
    {
        logger.debug("volumeChanged: output volume changed change detection fired (mechanism 2)")

        if let outputVolume = notification.userInfo![volumeChangedNotificationDictionaryKey()] as? Float
        {
            logger.debug("volumeChanged: Volume now \(String(describing: outputVolume))")

            DispatchQueue.main.async
            {
                self.appDelegate.musicPlaybackManager!.systemVolumeDidChange(volume: Double(outputVolume))
            }
        }
    }

    // MARK: - ACTIONS

    @IBAction func playMusic(_ sender: UIButton)
    {
        if let musicPlaybackManager = self.appDelegate.musicPlaybackManager,
           let playlistID = sender.accessibilityIdentifier
        {
            musicPlaybackManager.switchToPlaylist(playlistID: playlistID)
        }
    }
    
    @IBAction func userIsMovingSlider()
    {
        self.ignorePositionUpdates = true
    }

    @IBAction func userReleasedSlider()
    {
        self.ignorePositionUpdates = false

        if let musicPlayerManager = self.appDelegate.musicPlaybackManager
        {
            musicPlayerManager.positionSliderWasManuallyMoved(value: self.positionSlider.value)
        }
    }

    @IBAction func sliderPositionChangedByUser()
    {
        setPlayPositionTextFor(
            duration: positionSlider.maximumValue,
            position: positionSlider.value
        )
    }

    // MARK: - MusicPlaybackManagerDelegate

    func playbackStarted(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track)
    {
        var playlistName      = inPlaylist.displayName ?? ""
        let droppablePrefixes = ["Any - ", "Valhalla "]

        for droppablePrefix in droppablePrefixes
        {
            if playlistName.hasPrefix(droppablePrefix) {
                playlistName = String(playlistName.dropFirst(droppablePrefix.count))
            }
        }

        let labelText = attributedLabelText(playlistName: playlistName, trackTitle: withTrack.displayName)

        self.playlistAndTrackName.attributedText = labelText
        self.playPosition.text = "⏳"
        self.positionSlider.setValue(0, animated: false)

        if self.labelTimer != nil
        {
            self.labelTimer!.invalidate()
            self.labelTimer = nil
        }

        if let altDisplayName = withTrack.altDisplayName
        {
            var showingAlt = false

            self.labelTimer = Timer.scheduledTimer(
                withTimeInterval: 5.0,
                         repeats: true
            )
            { timer in
                var newLabelText : NSMutableAttributedString

                newLabelText = showingAlt
                             ? self.attributedLabelText(playlistName: inPlaylist.displayName, trackTitle: withTrack.displayName)
                             : self.attributedLabelText(playlistName: inPlaylist.displayName, trackTitle: altDisplayName)

                showingAlt = !showingAlt

                UIView.transition(
                          with: self.playlistAndTrackName,
                      duration: 0.25,
                       options: .transitionCrossDissolve,
                    animations: { [weak self] in
                                    self!.playlistAndTrackName.attributedText = newLabelText
                                },
                    completion: nil
                )
            }
        }
    }

    func playbackProgressChanged(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track, position: TimeInterval, duration: TimeInterval)
    {
        guard self.ignorePositionUpdates == false else { return }

        let relativePosition = position - withTrack.startOffset
        var relativeDuration: TimeInterval

        if withTrack.endOffset == nil
        {
            relativeDuration = duration - withTrack.startOffset
        }
        else
        {
            relativeDuration = (withTrack.endOffset! - withTrack.startOffset)
        }

        let floatDuration = Float(relativeDuration)
        let floatPosition = Float(relativePosition)

        self.positionSlider.minimumValue = 0
        self.positionSlider.maximumValue = floatDuration
        self.positionSlider.setValue(floatPosition, animated: false)

        setPlayPositionTextFor(
            duration: floatDuration,
            position: floatPosition
        )
    }

    func playbackPaused(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackResumed(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackArtworkWasDetermined(artwork: MusicKit.Artwork)
    {
        let rect       = UIScreen.main.bounds
        let longest    = max(rect.width, rect.height)
        let size       = CGSize(width: longest, height: longest)
        let urlToUse   = artwork.url(width: Int(longest), height: Int(longest))

        if urlToUse != nil
        {
            Task
            {
                do
                {
                    let (data, _) = try await URLSession.shared.data(from: urlToUse!)
                    let imageToUse = UIImage(data: data)

                    if imageToUse != nil
                    {
                        DispatchQueue.main.async
                        {
                            self.currentArtworkImage = imageToUse
                            self.updateArtworkToCurrent(usingSize: size)
                        }
                    }
                }
                catch {}
            }
        }
    }

    func playbackArtworkWillBeInvalid()
    {
        // Right now this is ignored, as the animation effect isn't great and
        // a cross-fade between different album artwork is nice. Kept around
        // "just in case".
        //
        // let rect    = UIScreen.main.bounds
        // let longest = max(rect.width, rect.height)
        // let size    = CGSize(width: longest, height: longest)
        //
        // self.currentArtworkImage = nil
        // updateArtworkToCurrent(usingSize: size)
    }

    func updateArtworkToCurrent(usingSize: CGSize)
    {
        var imageToUse     = self.currentArtworkImage
        let storyboardName = self.storyboard?.value(forKey: "name") as? String

        if let originalImage = imageToUse
        {
            let ciContext = CIContext(options: nil)
            var ciFilter: CIFilter?
            
            if (storyboardName != nil && storyboardName == "Valhalla")
            {
                ciFilter = CIFilter(name: "CIPhotoEffectFade")
            }
            else
            {
                ciFilter = CIFilter(name: "CISepiaTone")
            }

            if let coreImage = CIImage(image: originalImage),
               let filter    = ciFilter
            {
                filter.setDefaults()
                filter.setValue(coreImage, forKey: kCIInputImageKey)

                let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage

                if let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
                {
                    imageToUse = UIImage(cgImage: filteredImageRef)
                }
            }
        }

        // Customise the image view to fade edges and round corners.
        //
        if let imageToBlur  = imageToUse,
           let blurredImage = processArtwork(artworkImage: imageToBlur, minSize: usingSize)
        {
            imageToUse = blurredImage
        }

        if let imageView = self.albumArtImageView
        {
            UIView.transition(
                      with: imageView,
                  duration: 2.0,
                   options: .transitionCrossDissolve,
                animations:
                {
                    imageView.image = imageToUse
                },
                completion: nil
            )
        }
    }

    // MARK: - PRIVATE (GRAPHICS)

    /// https://apprize.best/apple/drawing/8.html
    ///
    func getUIKitContextSize() -> CGSize
    {
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else { return CGSize.zero }

        let scale = UIScreen.main.scale
        let size  = CGSize(
             width: context!.width,
            height: context!.height
        )

        return CGSize(
             width: size.width / scale,
            height: size.height / scale
        )
    }

    /// https://apprize.best/apple/drawing/2.html
    ///
    func flipContextVertically(size: CGSize)
    {
        if let context = UIGraphicsGetCurrentContext()
        {
            var transform = CGAffineTransform.identity

            transform = transform.scaledBy(x: 1.0, y: -1.0)
            transform = transform.translatedBy(x: 0.0, y: -size.height)

            context.concatenate(transform)
        }
    }

    /// https://apprize.best/apple/drawing/8.html
    ///
    func drawIntoImage(size: CGSize, drawingBlock: () -> Void) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        drawingBlock()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// https://apprize.best/apple/drawing/8.html
    ///
    func gaussianBlurImage(image: UIImage, radius: CGFloat) -> UIImage?
    {
        var blurredResult: UIImage? = nil

        if let blurFilter = CoreImage.CIFilter(name: "CIGaussianBlur"),
           let cropFilter = CoreImage.CIFilter(name: "CICrop"),
           let cgImage    = image.cgImage
        {
            let ciImage = CIImage(cgImage: cgImage)

            blurFilter.setValue(radius, forKey: "inputRadius")
            blurFilter.setValue(ciImage, forKey: "inputImage")

            if let blurredImage = blurFilter.outputImage
            {
                cropFilter.setDefaults()
                cropFilter.setValue(blurredImage, forKey: "inputImage")

                // Apply crop

                let scale = UIScreen.main.scale
                let w     = image.size.width  * scale
                let h     = image.size.height * scale
                let v     = CoreImage.CIVector(x: 0, y: 0, z: w, w: h)

                cropFilter.setValue(v, forKey: "inputRectangle")

                if let croppedImage = cropFilter.outputImage
                {
                    let ciContext  = CoreImage.CIContext(options: nil)

                    if let cgImageRef = ciContext.createCGImage(croppedImage, from: croppedImage.extent)
                    {
                        // Render the cropped, blurred results

                        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)

                        // Flip for Quartz drawing

                        flipContextVertically(size: image.size)

                        // Draw the image

                        if let currentContext = UIGraphicsGetCurrentContext()
                        {
                            currentContext.draw(
                                cgImageRef,
                                in: CGRect(x: 0, y: 0, width:image.size.width, height: image.size.height)
                            )

                            blurredResult = UIGraphicsGetImageFromCurrentImageContext()
                        }

                        UIGraphicsEndImageContext()
                    }
                }
            }
        }

        return blurredResult
    }

    /// https://apprize.best/apple/drawing/8.html
    ///
    func drawAndBlur(blurRadius: CGFloat, drawingBlock: () -> Void) -> Void
    {
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else { return }

        if let baseImage = drawIntoImage(size: getUIKitContextSize(), drawingBlock: drawingBlock),
           let blurred = gaussianBlurImage(image: baseImage, radius: blurRadius)
        {
            blurred.draw(at: CGPoint.zero)
        }
    }

    /// https://apprize.best/apple/drawing/4.html
    ///
    func greyscaleVersionOfImage(sourceImage: UIImage) -> UIImage?
    {
        // Establish grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width      = sourceImage.size.width
        let height     = sourceImage.size.height

        // Build context: one byte per pixel, no alpha
        if let context = CGContext.init(
                        data: nil,
                       width: Int(width),
                      height: Int(height),
            bitsPerComponent: Int(8),
                 bytesPerRow: 0,
                       space: colorSpace,
                  bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        )
        {
            // Replicate image using new color space
            let rect = CGRect(x: 0, y: 0, width: width, height: height)

            if let cgImage = sourceImage.cgImage
            {
                context.draw(cgImage, in: rect)

                // Return the grayscale image
                if let imageRef = context.makeImage()
                {
                    return UIImage(cgImage: imageRef)
                }
            }
        }

        return nil
    }

    /// https://apprize.best/apple/drawing/8.html
    ///
    func applyMaskToContext(mask: UIImage)
    {
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else { return }

        // Ensure that mask is grayscale
        if let grey = greyscaleVersionOfImage(sourceImage: mask),
           let greyCgImage = grey.cgImage
        {
            // Determine the context size
            let size        = CGSize(width: context!.width, height: context!.height)
            let scale       = UIScreen.main.scale
            let contextSize = CGSize(width: size.width / scale, height: size.height / scale)
            let contextRect = CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height)

            // Update the GState for masking
            flipContextVertically(size: contextSize)
            context!.clip(to: contextRect, mask: greyCgImage)
            flipContextVertically(size: contextSize)
        }
    }

    /**
     Process artwork with a blurred edge and rounded corners, scaling to fit a minimum size if need be.

     Based on https://apprize.best/apple/drawing/8.html

     - Parameters:
         - artworkImage: Image to process
         - minSize: Minimum size (so long as the artwork is larger than any one edge, its size is used))
    */
    func processArtwork(artworkImage: UIImage, minSize: CGSize?) -> UIImage?
    {
        let imageRect = minSize == nil ||
            (artworkImage.size.width >= minSize!.width || artworkImage.size.height > minSize!.height)
            ? CGRect(x: 0, y: 0, width: artworkImage.size.width, height: artworkImage.size.height)
            : CGRect(x: 0, y: 0, width:          minSize!.width, height:          minSize!.height)

        let multiplier = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 0.02 : 0.035)
        let edges      = imageRect.width * multiplier
        let insetRect  = imageRect.insetBy(dx: edges, dy: edges)
        let path       = UIBezierPath(roundedRect: insetRect, cornerRadius: edges * 1.5)

        if let mask = drawIntoImage(
                    size: imageRect.size,
            drawingBlock: {
                if let context = UIGraphicsGetCurrentContext()
                {
                    context.setFillColor(UIColor.black.cgColor)
                    context.fill(imageRect)

                    drawAndBlur(blurRadius: edges) {
                        if let context = UIGraphicsGetCurrentContext()
                        {
                            context.setFillColor(UIColor.white.cgColor)
                            path.fill()
                        }
                    }
                }
            }
        )
        {
            let result = drawIntoImage(
                        size: imageRect.size,
                drawingBlock: {
                    applyMaskToContext(mask: mask)
                    artworkImage.draw(in: imageRect)
                }
            )

            return result
        }

        return nil
    }

    // MARK: - PRIVATE (GENERAL)

    private func setPlayPositionTextFor(duration: Float, position: Float)
    {
        let remainingTime    = duration - position
        let minutes          = Int(remainingTime / 60)
        let seconds          = Int(remainingTime.truncatingRemainder(dividingBy: 60))
        let minutesDisplay   = minutes > 0 ? "\(minutes)m " : ""
        let secondsDisplay   = minutes > 0 && seconds < 10 ? "0\(seconds)s"  : "\(seconds)s"

        self.playPosition.text = "\(minutesDisplay)\(secondsDisplay)"
    }

    private func musicAuthorizationIsGranted()
    {
        logger.notice("musicAuthorizationIsGranted: Authorisation is available, kicking off initial playback start")
        self.appDelegate.musicPlaybackManager!.startPlaybackAtAppLaunch()
    }

    private func musicAuthorizationIsDenied()
    {
        UnfixableError().display(message: "You prohibited Dungeon Panda from accessing Apple Music.\n\nIt is forever doomed.", using: self)
    }

    /**
     Return attributed text to assign to a UILabel which describes the given playlist name and track title.

     - Parameters:
     - playlistName: Optional playlist name to use.
     - trackTitle: Title of track to use.

     - Returns: Attributed text for use in e.g. a UILabel.
     */
    private func attributedLabelText(playlistName: String?, trackTitle: String) -> NSMutableAttributedString
    {
        let fontSize      = CGFloat(22)
        let boldFont      = UIFont(name: "Baskerville-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let normalFont    = UIFont(name: "Baskerville",      size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let nameWithColon = playlistName == nil ? "" : "\(playlistName!): "

        let playlistText  = NSAttributedString(string: nameWithColon, attributes: [.font: boldFont  ])
        let trackText     = NSAttributedString(string: trackTitle,    attributes: [.font: normalFont])
        let labelText     = NSMutableAttributedString()

        labelText.append(playlistText)
        labelText.append(trackText)

        return labelText
    }
    
    // MARK: - Catalyst audio volume workaround
    
    // C-compatible static function pointer for AudioObjectAddPropertyListener on Catalyst builds
    //
    private static let macCatalystAudioVolumeChangedCBPointer: AudioObjectPropertyListenerProc = { audioObjectID, numberOfAddresses, addresses, clientData in
        return macCatalystVolumeCallbackViewController?.macCatalystAudioVolumeChangedCB(
            audioObjectID:     audioObjectID,
            numberOfAddresses: numberOfAddresses,
            addresses:         addresses,
            clientData:        clientData
        ) ?? noErr
    }
    
    // Instance method called from the static callback function pointer; performs volume update on main thread
    //
    private func macCatalystAudioVolumeChangedCB(audioObjectID: AudioObjectID, numberOfAddresses: UInt32, addresses: UnsafePointer<AudioObjectPropertyAddress>, clientData: UnsafeMutableRawPointer?) -> OSStatus {
        var currentSystemVolume: Float32 = 0
        var size = UInt32(MemoryLayout<Float32>.size)
        var volumeAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope:    kAudioObjectPropertyScopeOutput,
            mElement:  kAudioObjectPropertyElementMain
        )

        AudioObjectGetPropertyData(audioObjectID, &volumeAddress, 0, nil, &size, &currentSystemVolume)

        if currentSystemVolume != macCatalystVolumeCallbackViewController?.previousSystemVolume
        {
            macCatalystVolumeCallbackViewController?.previousSystemVolume = currentSystemVolume
            DispatchQueue.main.async {
                macCatalystVolumeCallbackViewController?.appDelegate.musicPlaybackManager?.systemVolumeDidChange(volume: Double(currentSystemVolume))
            }
        }

        return noErr
    }
}
