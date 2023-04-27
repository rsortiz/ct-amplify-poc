//
//  AuthService.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import AWSPluginsCore

class AuthService: ObservableObject {
    
    @Published var isSignedIn = false
    
    func signUp(username: String, password: String, email: String, completion: @escaping (Bool, String?) -> ()) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    completion(true, nil)
                } else {
                    print("SignUp Complete")
                    completion(true, nil)
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
                completion(false, error.errorDescription)
            }
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String, completion: @escaping (Bool, String?) -> ()) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
                completion(true, nil)
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
                completion(false, error.errorDescription)
            }
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Bool, String?) -> ()) async throws {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                self.isUserLoggedIn(completion: completion)
            case .failure(let error):
                print("Sign in failed \(error)")
                completion(false, "Sign in failed \(error)")
            }
        }
    }
    
    func isUserLoggedIn(completion: @escaping (Bool, String?) -> ()) {
    
        Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()

                // Get user sub or identity id
                if let identityProvider = session as? AuthCognitoIdentityProvider {
                    let usersub = try identityProvider.getUserSub().get()
                    let identityId = try identityProvider.getIdentityId().get()
                    print("User sub - \(usersub) and identity id \(identityId)")
                    completion(true, usersub)
                } else {
                    completion(false, "Fetch auth session failed, userID not found")
                }

            } catch {
                completion(false, "Fetch auth session failed with error - \(error)")
            }
        }
    }
    
    func signOutGlobally(completion: @escaping (Bool, String?) -> ()) {
        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
            switch result {
            case .success:
                print("Successfully signed out")
                completion(true, nil)
            case .failure(let error):
                print("Sign out failed with error \(error)")
                completion(true, "Sign out failed with error \(error)")
            }
        }
    }
}
