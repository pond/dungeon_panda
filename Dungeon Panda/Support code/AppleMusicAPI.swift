//
//  AppleMusicAPI.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import StoreKit
import SwiftyJSON

// https://www.appcoda.com/musickit-music-api/
// https://stackoverflow.com/questions/65057320/skcloudservicecontroller-requestusertoken-freezes-on-ios-14-2
//
class AppleMusicAPI {

    // Update and release new app every <= 180 days - yes, for real :-/
    //
    let developerToken = "eyJhbGciOiJFUzI1NiIsImtpZCI6IjNDUkdZNjhYQTgifQ.eyJpc3MiOiJYVDRWOTc2RDhZIiwiaWF0IjoxNjE1Njc0NjY0LCJleHAiOjE2MzEyMjY2NjR9.IK9FCk6AglUgsTPmiMh4-veV-9euxLpisu0U3ewSDayi4ydlGeJ5ugf85vXFG9Iz9nsZ6Mc4C5312M8SSoxTrw"
    var storeFrontID: String?
    
    init() {
    }

    func getUserToken(completionHandler: @escaping(Result<String, Error>) -> Void) -> Void {
        SKCloudServiceController().requestUserToken(
            forDeveloperToken: developerToken,
            completionHandler: { (userToken, error) in
                if error != nil {
                    completionHandler(.failure(error!))
                }
                else {
                    completionHandler(.success(userToken!))
                }
            }
        )
    }
    
    func fetchStorefrontID(completionHandler: @escaping(Result<String, Error>) -> Void) -> Void {
        if self.storeFrontID != nil {
            completionHandler(.success(self.storeFrontID!))
            return // NOTE EARLY EXIT
        }

        getUserToken(
            completionHandler: { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
     
                case .success(let userToken):
                    let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
                    var musicRequest = URLRequest(url: musicURL)

                    musicRequest.httpMethod = "GET"
                    musicRequest.addValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
                    musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
                    
                    URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                        if let urlError = error as? URLError {
                          completionHandler(.failure(urlError))
                        }
                        else if let json = try? JSON(data: data!) {
                            let result = (json["data"]).array!
                            let id     = (result[0].dictionaryValue)["id"]!

                            self.storeFrontID = id.stringValue
                            completionHandler(.success(self.storeFrontID!))
                        }
                    }.resume()
                }
            }
        )
    }

    func searchAppleMusicWith(searchTerm: String!, completionHandler: @escaping((Result<[Song], Error>)) -> Void) -> Void {
        self.fetchStorefrontID(
            completionHandler: { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
     
                case .success(let storeFrontID):
                    self.getUserToken(
                        completionHandler: { result in
                            switch result {
                            case .failure(let error):
                                completionHandler(.failure(error))
                 
                            case .success(let userToken):
                                var songs = [Song]()
                                let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/\(storeFrontID)/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25")!
                                var musicRequest = URLRequest(url: musicURL)

                                musicRequest.httpMethod = "GET"
                                musicRequest.addValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
                                musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")

                                URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                                    if let urlError = error as? URLError {
                                      completionHandler(.failure(urlError))
                                    }
                                    else if let json = try? JSON(data: data!) {
                                        let items = (json["results"]["songs"]["data"]).array!
                                        for item in items {
                                            let attributes = item["attributes"]
                                            let song       = Song(
                                                id:         attributes["playParams"]["id"].string!,
                                                name:       attributes["name"].string!,
                                                artistName: attributes["artistName"].string!,
                                                artworkURL: attributes["artwork"]["url"].string!
                                            )

                                            songs.append(song)
                                        }

                                        completionHandler(.success(songs))
                                    }
                                }.resume()
                            }
                        }
                    )
                }
            }
        )
    }

    // Gets up to 100 library playlists WITHOUT songs.
    //
    func getAllLibraryPlaylists(completionHandler: @escaping((Result<[LibraryPlaylist], Error>)) -> Void) -> Void {
        getUserToken(
            completionHandler: { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
     
                case .success(let userToken):
                    var playlists = [LibraryPlaylist]()
                    let musicURL = URL(string: "https://api.music.apple.com/v1/me/library/playlists?limit=100")!
                    var musicRequest = URLRequest(url: musicURL)

                    musicRequest.httpMethod = "GET"
                    musicRequest.addValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
                    musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
                    
                    URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                        if let urlError = error as? URLError {
                          completionHandler(.failure(urlError))
                        }
                        else if let json = try? JSON(data: data!) {
                            if let errorArray = json["errors"].array {
                                var firstError:String? = errorArray[0]["detail"].string
                                if firstError == nil {
                                    firstError = "Unknown problem encountered while fetching content from Apple Music"
                                }
                                
                                let errorObject = MiscError(kind: .appleMusic, message: firstError!)
                                completionHandler(.failure(errorObject))
                                return
                            }
                            
                            let items = (json["data"]).array!
                            for item in items {
                                let attributes = item["attributes"]
                                let playlist   = LibraryPlaylist(
                                    id:         attributes["playParams"]["id"].string!,
                                    name:       attributes["name"].string!,
                                    artworkURL: attributes["artwork"]["url"].string
                                )
                                playlists.append(playlist)
                            }

                            completionHandler(.success(playlists))
                        }
                    }.resume()
                }
            }
        )
    }

    // Gets songs for a specific playlist; optionally, only returns Apple Music
    // catalogue items.
    //
    func getLibraryPlaylistSongs(
        playlistID:        String,
        catalogueOnly:     Bool,
        completionHandler: @escaping((Result<[Song], Error>)) -> Void
    ) -> Void {
        getUserToken(
            completionHandler: { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
     
                case .success(let userToken):
                    var songs = [Song]()
                    let musicURL = URL(string: "https://api.music.apple.com/v1/me/library/playlists/\(playlistID)?include=tracks")!
                    var musicRequest = URLRequest(url: musicURL)

                    musicRequest.httpMethod = "GET"
                    musicRequest.addValue("Bearer \(self.developerToken)", forHTTPHeaderField: "Authorization")
                    musicRequest.addValue(userToken, forHTTPHeaderField: "Music-User-Token")
                    
                    URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                        if let urlError = error as? URLError {
                          completionHandler(.failure(urlError))
                        }
                        else if let json = try? JSON(data: data!) {
                            let playlists = (json["data"]).array!
                            let playlist  = playlists[0] // Always the only array entry
                            let items     = (playlist["relationships"]["tracks"]["data"]).array!

                            for item in items {
                                let attributes   = item["attributes"]
                                let localUserId  = attributes["playParams"]["id"].string
                                let appleMusicId = attributes["playParams"]["catalogId"].string
                                
                                if catalogueOnly == false || appleMusicId != nil {
                                    let song = Song(
                                        id:         appleMusicId == nil ? localUserId! : appleMusicId!,
                                        name:       attributes["name"].string!,
                                        artistName: attributes["artistName"].string,
                                        artworkURL: attributes["artwork"]["url"].string
                                    )
                                    songs.append(song)
                                }
                            }

                            completionHandler(.success(songs))
                        }
                    }.resume()
                }
            }
        )
    }}
