//
//  SceneDelegate.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import UIKit
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let logger = Logger()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let windowScene          = scene as? UIWindowScene
        let lastPlayedPlaylistID = self.appDelegate.playlistManager!.currentPlaylist.playlistID

        // If there's a prior session via CoreData indicating a Valhalla playlist
        // then switch to the Valhalla storyboard immediately, so the application
        // appears to launch in the right mode straight away. We do nothing if
        // not, since the UI resources launch the Main storyboard by default.
        //
        // See also ViewController's viewDidLoad for where we change playlist if
        // the storyboard is swapped between Main and Valhalla later by the user.
        //
        if lastPlayedPlaylistID != nil && windowScene != nil && lastPlayedPlaylistID!.contains("valhalla-")
        {
            let window                = UIWindow(windowScene: windowScene!)
            let storyboard            = UIStoryboard(name: "Valhalla", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()

            window.rootViewController = initialViewController
            self.window               = window

            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

