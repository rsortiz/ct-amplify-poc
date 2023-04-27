//
//  BookingService.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI
import Amplify
import AmplifyPlugins

class BookingService: ObservableObject {
    func createBooking(resID: String, username: String, completion: @escaping (Bool) -> ()) {
        let booking = Booking(id: resID, resID: resID, username: username)
        Amplify.API.mutate(request: .create(booking)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let todo):
                    print("Successfully created the todo: \(todo)")
                    completion(true)
                case .failure(let graphQLError):
                    print("Failed to create graphql \(graphQLError)")
                    completion(false)
                }
            case .failure(let apiError):
                print("Failed to create a todo", apiError)
                completion(false)
            }
        }
    }
}
