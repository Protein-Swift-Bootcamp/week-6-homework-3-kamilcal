//
//  AppDelegate.swift
//  NewsApp
//
//  Created by kamilcal on 10.01.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Load the shared persistent store
        DataController.shared.loadPersistentStore()
        
        let fetchRequest: NSFetchRequest<Country> = Country.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                let initialVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.window?.rootViewController = initialVC
            } else {
                let initialVC = storyboard.instantiateViewController(withIdentifier: "CountrySelectionViewController") as! CountrySelectionViewController
                self.window?.rootViewController = initialVC
            }
        }
        return true
    }
    
    // Save the view context when the app is in the background
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    // Save the view context when the app terminates or crashes
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
    
    // MARK: Helper methods
    // A helper method that saves changes to the persistent store
    func saveViewContext() {
        try? DataController.shared.viewContext.save()
    }
}
