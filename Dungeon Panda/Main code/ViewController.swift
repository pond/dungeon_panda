//
//  ViewController.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import UIKit
import StoreKit
import MediaPlayer

class ViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    let appleMusic = AppleMusicAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func playMusic(_ sender: UIButton) {
        SKCloudServiceController.requestAuthorization { (status) in
            if status == .authorized {
                print("User authorized access to Apple Music")

                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                if let playlistID = sender.accessibilityIdentifier {
//                    appDelegate.musicPlaybackManager.changePlaylist(playlistID: playlistID)
                }

                
                
                
                
//                self.appleMusic.searchAppleMusicWith(
//                    searchTerm: "The Forest of the Gods",
//                    completionHandler: { result in
//                        switch result {
//                        case .failure(let error):
//                            print("Failed:")
//                            print(error)
//                        case .success(let songs):
//                            print("Success:")
//                            for song in songs {
//                                print(song)
//                            }
//
//                            let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
//                            musicPlayer.setQueue(with: [songs[0].id])
//                            musicPlayer.play()
//                        }
//                    }
//                )
            }
        }
    }
}
