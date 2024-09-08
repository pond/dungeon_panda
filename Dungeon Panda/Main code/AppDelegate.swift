//
//  AppDelegate.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import UIKit
import CoreData
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var staticTracklistManager: StaticTracklistManager?
    public var playlistManager: PlaylistManager?
    public var musicPlaybackManager: MusicPlaybackManager?
    public var musicAuthorizationStatus: SKCloudServiceAuthorizationStatus? // Set in ViewController's 'viewDidLoad'
    public var useSystemVolumeNotificationsInsteadOfKvo: Bool = false

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool
    {
        self.staticTracklistManager = StaticTracklistManager()
        self.playlistManager        = PlaylistManager(staticTracklistManager: self.staticTracklistManager!, persistentContainer: self.persistentContainer)
        self.musicPlaybackManager   = MusicPlaybackManager(playlistManager: self.playlistManager!)

        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container   = NSPersistentContainer(name: "Dungeon_Panda")
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores {_, error in
            if error != nil {
                fatalError("persistentContainer: Core Data error - \(error!)")
            }
        }

        return container
    }()
    
    lazy var cloudKitPersistentContainer: NSPersistentCloudKitContainer = {
        let appTransactionAuthorName = "uk.org.pond.Dungeon-Panda"

        // Create a container that can load CloudKit-backed stores
        let container = NSPersistentCloudKitContainer(name: "Dungeon_Panda")
        let description = container.persistentStoreDescriptions.first
        description?.setOption(false as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores(
            completionHandler:
            {
                (storeDescription, error) in
                if let error = error as NSError?
                {
                    guard let error = error as NSError? else { return }
                    UnfixableError().display(message: "iCloud failed to load persistent stores: \(error)", using: nil)
                }
            }
        )

        // Pin the viewContext to the current generation token and set it to
        // keep itself up to date with local changes.
        //
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName
        container.viewContext.automaticallyMergesChangesFromParent = true

        do
        {
            try container.viewContext.setQueryGenerationFrom(.current)
        }
        catch
        {
            UnfixableError().display(message: "iCloud failed to pin viewContext to the current generation: \(error)", using: nil)
        }

        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
