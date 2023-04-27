//
//  AuthService.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI
import Amplify
import AmplifyPlugins

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
                completion(true, nil)
            case .failure(let error):
                print("Sign in failed \(error)")
                completion(false, "Sign in failed \(error)")
            }
        }
    }
    
    func isUserLoggedIn(completion: @escaping (Bool) -> ()) {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
                completion(session.isSignedIn)
            case .failure(let error):
                print("Fetch session failed with error \(error)")
                completion(false)
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
