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
            // Configure Amplify as usual...
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
            
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            print("Amplify configured with auth plugin")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }

        return true
    }
}
