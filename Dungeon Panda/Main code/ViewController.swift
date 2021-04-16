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

    let appleMusic  = AppleMusicAPI()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var volumeView: MPVolumeView?
    var labelTimer: Timer?
    var ignorePositionUpdates: Bool = false

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
                            y: 8,
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
            musicPlaybackManager.changePlaylist(playlistID: playlistID)
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
        let minutesDisplay   = minutes > 0  ? "\(minutes)m " : ""
        let secondsDisplay   = seconds > 10 ? "\(seconds)s"  : "0\(seconds)s"

        self.playPosition.text = "-\(minutesDisplay)\(secondsDisplay)"
        self.positionSlider.setValue(Float(relativePosition / (relativeDuration - 1)), animated: false)
    }

    func playbackPaused(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackResumed(playbackManager: MusicPlaybackManager)
    {
    }

    // MARK: - PRIVATE

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
