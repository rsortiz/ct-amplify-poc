//
//  AppDelegate.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import Foundation
import Amplify
import AmplifyPlugins

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
//            Amplify.Logging.logLevel = .verbose
            
            // Configure Amplify as usual...
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        
        return true
    }
}
