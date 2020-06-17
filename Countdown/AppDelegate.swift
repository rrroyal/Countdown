//
//  AppDelegate.swift
//  Countdown
//
//  Created by royal on 11/06/2020.
//  Copyright © 2020 shameful. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	public lazy var storeModel: StoreModel = StoreModel()
	public lazy var timer: AppTimer = AppTimer.shared
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		UITableView.appearance().separatorStyle = .none
		return true
	}

	// MARK: UISceneSession Lifecycle
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		self.saveAppData()
	}

	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
		let container: NSPersistentContainer = NSPersistentContainer(name: "Countdowns")
		
		let storeURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Bundle.main.object(forInfoDictionaryKey: "GroupIdentifier") as? String ?? "")!.appendingPathComponent("Countdowns.sqlite")
		let description: NSPersistentStoreDescription = NSPersistentStoreDescription()
		description.shouldInferMappingModelAutomatically = true
		description.shouldMigrateStoreAutomatically = true
		description.url = storeURL
		
		container.persistentStoreDescriptions = [description]
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error {
				print("[!] (CoreData) Could not load store: \(error.localizedDescription)")
				return
			}
			
			print("[*] (CoreData) Store loaded!")
		})
		
		return container
	}()

	// MARK: - Core Data Saving support
	func saveContext() {
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
	
	/// Creates or updates CoreData (forgive me)
	/// - Parameters:
	///   - forEntityName: Entity name to search for
	///   - forKey: Key to search/set for
	///   - object: Object that is being set
	func createOrUpdate(forEntityName entityName: String, forKey key: String, value: Data) {
		let context = self.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
		do {
			let response = try context.fetch(fetchRequest)
			if let object = response.first {
				object.setValue(value, forKey: key)
			} else {
				let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
				object.setValue(value, forKey: key)
			}
		} catch {
			print("[!] (CoreData) Could not fetch: \(error)")
		}
		
		self.saveContext()
	}
	
	/// Saves app data that might be modified during the runtime.
	func saveAppData() {
		print("[*] (AppDelegate) Saving app data.")
		let jsonEncoder = JSONEncoder()
		do {
			let countdowns = try jsonEncoder.encode(self.storeModel.countdowns)
			self.createOrUpdate(forEntityName: "Countdowns", forKey: "savedCountdowns", value: countdowns)
			self.saveContext()
			
			// try WatchSessionManager.shared.updateApplicationContext(applicationContext: ["type": "coreData", "data": ["countdowns": countdowns])
		} catch {
			print("[!] (AppDelegate) Error encoding data: \(error)")
		}
	}

}

