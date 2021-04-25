//
//  ViewController.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import UIKit
import StoreKit
import MediaPlayer

class ViewController: UIViewController, MusicPlaybackManagerDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playlistAndTrackName: UILabel!
    @IBOutlet weak var playPosition: UILabel!
    @IBOutlet weak var positionSlider: UISlider!
    @IBOutlet weak var volumeParentView: UIView!
    @IBOutlet weak var albumArtImageView: UIImageView!

    let appleMusic  = AppleMusicAPI()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var volumeView: MPVolumeView?
    var labelTimer: Timer?
    var ignorePositionUpdates: Bool = false
    var currentArtworkImage: UIImage? = nil

    // MARK: - VIEW LIFECYCLE

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.playlistAndTrackName.text = "Not playing"
        self.playPosition.text = "…"
        self.positionSlider.setValue(0, animated: false)

        self.appDelegate.musicPlaybackManager!.delegates.append(self)

        // Add the volume view.
        //
        // When placed to match bounds exactly, the view is actually displaced
        // some distance vertically above the requested region, actually
        // spilling out if its container. Sigh.
        //
        let bounds = CGRect(x: 0,
                            y: 7,
                            width: self.volumeParentView.bounds.width,
                            height: self.volumeParentView.bounds.height)

        self.volumeView = MPVolumeView(frame: bounds)
        self.volumeParentView.addSubview(self.volumeView!)

        self.volumeView!.setVolumeThumbImage(UIImage(named: "Volume slider"), for: .normal)
        self.positionSlider.setThumbImage(UIImage(named: "Position slider"), for: .normal)

        // Track alterations in system volume by the user so that fade in/out
        // etc. can all work relative to this user-chosen baseline.
        //
        UIApplication.shared.beginReceivingRemoteControlEvents()

        NotificationCenter.default.addObserver(
                self,
            selector: #selector(systemVolumeDidChange(_ :)),
                name: Notification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
             object: nil
        )

        // Obtain Apple Music authorisation if need be.
        //
        let authorizationStatus = SKCloudServiceController.authorizationStatus()
        if authorizationStatus == .authorized || authorizationStatus == .restricted
        {
            print("ViewController.viewDidLoad: User authorized access to Apple Music")
            musicAuthorizationIsGranted()
        }
        else if authorizationStatus == .denied
        {
            print("ViewController.viewDidLoad: User prohibited access to Apple Music")
            musicAuthorizationIsDenied()
        }
        else
        {
            print("ViewController.viewDidLoad: Requesting access to Apple Music")
            getMusicAuthorizationFromUser()
        }
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        let hiddenSystemVolumeSlider = self.volumeView!.subviews.first(where: { $0 is UISlider }) as? UISlider
        print("Volume sider is \(String(describing: hiddenSystemVolumeSlider))")

        self.appDelegate.musicPlaybackManager!.setHiddenSystemVolumeSlider(hiddenSystemVolumeSlider)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        updateArtworkToCurrent()
    }

    override func viewDidDisappear(_ animated: Bool)
    {
        UIApplication.shared.endReceivingRemoteControlEvents()

        NotificationCenter.default.removeObserver(self)

        super.viewWillDisappear(animated)
    }

    // MARK: - ACTIONS

    @IBAction func playMusic(_ sender: UIButton)
    {
        if let musicPlaybackManager = self.appDelegate.musicPlaybackManager,
           let playlistID = sender.accessibilityIdentifier
        {
            musicPlaybackManager.startPlayingNextInPlaylist(playlistID: playlistID)
        }
    }

    @IBAction func userIsMovingSlider()
    {
        self.ignorePositionUpdates = true
    }

    @IBAction func userReleasedSlider()
    {
        self.ignorePositionUpdates = false
    }

    @IBAction func sliderPositionChangedByUser()
    {
        if let musicPlayerManager = self.appDelegate.musicPlaybackManager
        {
            musicPlayerManager.positionSliderWasManuallyMoved(value: self.positionSlider.value)
        }
    }

    // MARK: - MusicPlaybackManagerDelegate

    func playbackStarted(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track)
    {
        let labelText = attributedLabelText(playlistName: inPlaylist.displayName, trackTitle: withTrack.displayName)

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

        let remainingTime    = relativeDuration - relativePosition
        let minutes          = Int(remainingTime / 60)
        let seconds          = Int(remainingTime.truncatingRemainder(dividingBy: 60))
        let minutesDisplay   = minutes > 0 ? "\(minutes)m " : ""
        let secondsDisplay   = minutes > 0 && seconds < 10 ? "0\(seconds)s"  : "\(seconds)s"

        self.playPosition.text = "-\(minutesDisplay)\(secondsDisplay)"
        self.positionSlider.setValue(Float(relativePosition / (relativeDuration - 1)), animated: false)
    }

    func playbackPaused(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackResumed(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackArtworkWasDetermined(artwork: MPMediaItemArtwork)
    {
        let rect       = self.albumArtImageView.bounds
        let size       = CGSize(width: rect.width, height: rect.height)
        var imageToUse = artwork.image(at: size)

        if imageToUse == nil && artwork.bounds.width > 0
        {
            imageToUse = artwork.image(at: CGSize(width: artwork.bounds.width, height: artwork.bounds.height))
        }

        self.currentArtworkImage = imageToUse
        updateArtworkToCurrent()
    }

    func updateArtworkToCurrent()
    {
        var imageToUse = self.currentArtworkImage

        if let originalImage = imageToUse
        {
            let ciContext = CIContext(options: nil)

            if let coreImage = CIImage(image: originalImage),
               let filter = CIFilter(name: "CISepiaTone") // CIPhotoEffectFade is also decent
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
           let blurredImage = processArtwork(artworkImage: imageToBlur, minSize: self.albumArtImageView?.bounds.size)
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
            width:  context!.width,
            height: context!.height
        )

        return CGSize(
            width:  size.width / scale,
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

        let edges     = imageRect.width * 0.025
        let insetRect = imageRect.insetBy(dx: edges, dy: edges)
        let path      = UIBezierPath(roundedRect: insetRect, cornerRadius: edges * 1.5)

        if let mask = drawIntoImage(
            size: imageRect.size,
            drawingBlock:
                {
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
                drawingBlock:
                    {
                        applyMaskToContext(mask: mask)
                        artworkImage.draw(in: imageRect)
                    }
            )

            return result
        }

        return nil
    }

    // MARK: - PRIVATE (GENERAL)

    private func getMusicAuthorizationFromUser()
    {
        SKCloudServiceController.requestAuthorization { (status) in
            if status == .authorized || status == .restricted
            {
                print("getMusicAuthorizationFromUser: User authorized access to Apple Music")

                AppleMusicAPI().getUserToken(
                    completionHandler: { result in
                        switch result {
                            case .failure(let error):
                                print("getMusicAuthorizationFromUser: ERROR - User token failure - \(error)")
                                UnfixableError().display(message: error.localizedDescription, using: self)

                            case .success(let userToken):
                                print("getMusicAuthorizationFromUser: User token \(userToken) retrieved; starting playback")
                                self.musicAuthorizationIsGranted()
                        }
                    }
                )
            }
            else
            {
                self.musicAuthorizationIsDenied()
            }
        }
    }

    private func musicAuthorizationIsGranted()
    {
        print("musicAuthorizationIsGranted: Authorisation is available, kicking off initial playback start")
        self.appDelegate.musicPlaybackManager!.startInitialPlayback()
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

    /**
     Tell the MusicPlaybackManager instance that we detected a change in system volume.

     - Parameter notification: Notification payload.
    */
    @objc func systemVolumeDidChange(_ notification: NSNotification) {
        let userInfo = notification.userInfo!
        let volume   = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as! Double

        appDelegate.musicPlaybackManager!.systemVolumeDidChange(volume: volume)
    }

    private func searchFor(searchTerm: String)
    {
        self.appleMusic.searchAppleMusicWith(
            searchTerm: searchTerm,
            completionHandler: { result in
                switch result {
                case .failure(let error):
                    print("Failed:")
                    print(error)
                case .success(let songs):
                    print("Success:")
                    for song in songs {
                        print(song)
                    }
                }
            }
        )
    }

    private func dumpPlaylists()
    {
        SKCloudServiceController.requestAuthorization { (status) in
            if status == .authorized {
                self.appleMusic.getAllLibraryPlaylists(
                    completionHandler: { result in
                        switch result {
                        case .failure(let error):
                            print("Failed:")
                            print(error)

                        case .success(let playlists):
                            print("")
                            print("Success:")

                            let semaphore = DispatchSemaphore(value: 1)

                            DispatchQueue.global().async
                            {
                                for playlist in playlists {
                                    print(playlist)
                                    if playlist.name.starts(with: "D&D") {
                                        semaphore.wait()
                                        print("")
                                        print(String(repeating: "*", count: 80))
                                        print(playlist.name)
                                        print(String(repeating: "*", count: 80))
                                        print("")
                                        self.appleMusic.getLibraryPlaylistSongs(
                                            playlistID: playlist.id,
                                            catalogueOnly: false,
                                            completionHandler: { result in
                                                switch result {
                                                case .failure(let error):
                                                    print("Failed:")
                                                    print(error)
                                                case .success(let songs):
                                                    print("Success:")
                                                    for song in songs {
                                                        print(song)
                                                    }
                                                }

                                                semaphore.signal()
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                )
            }
        }
    }
}
