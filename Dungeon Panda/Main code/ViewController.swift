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
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playPosition: UILabel!
    @IBOutlet weak var positionSlider: UISlider!
    
    let appleMusic = AppleMusicAPI()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.musicPlaybackManager!.delegates.append(self)
    }

    @IBAction func playMusic(_ sender: UIButton) {
        SKCloudServiceController.requestAuthorization { (status) in
            if status == .authorized {
                print("User authorized access to Apple Music")

                if let musicPlaybackManager = self.appDelegate.musicPlaybackManager,
                   let playlistID = sender.accessibilityIdentifier
                {
                    musicPlaybackManager.changePlaylist(playlistID: playlistID)
                }
            }
        }
    }

    // MARK: - MusicPlaybackManagerDelegate

    func playbackStarted(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track)
    {
        let fontSize = CGFloat(22)
        let boldFont = UIFont(name: "Baskerville-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let normalFont = UIFont(name: "Baskerville", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let nameWithColon = inPlaylist.displayName == nil ? "" : "\(inPlaylist.displayName!): "

        let playlistText = NSAttributedString(string: nameWithColon,         attributes: [.font: boldFont])
        let trackText    = NSAttributedString(string: withTrack.displayName, attributes: [.font: normalFont])
        let labelText    = NSMutableAttributedString()

        labelText.append(playlistText)
        labelText.append(trackText)

        self.playlistName.attributedText = labelText
        self.songTitle.text = ""//withTrack.displayName
        self.playPosition.text = ""
        self.positionSlider.setValue(0, animated: false)
    }

    func playbackProgressChanged(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track, position: TimeInterval, duration: TimeInterval)
    {
        let relativeDuration = duration - withTrack.startOffset - withTrack.endOffset
        let relativePosition = position - withTrack.startOffset
        let remainingTime = relativeDuration - relativePosition
        let minutes = Int(remainingTime / 60)
        let seconds = Int(remainingTime.truncatingRemainder(dividingBy: 60))

        self.playPosition.text = "-\(minutes)m \(seconds)s"
        self.positionSlider.setValue(Float(relativePosition / (relativeDuration - 1)), animated: false)
    }

    func playbackPaused(playbackManager: MusicPlaybackManager)
    {
    }

    func playbackResumed(playbackManager: MusicPlaybackManager)
    {
    }

    // MARK: - PRIVATE

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

                    let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
                    musicPlayer.setQueue(with: [songs[0].id])
                    musicPlayer.play()
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
                            DispatchQueue.global().async {
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
