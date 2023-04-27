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
    func createBooking(resID: String, userID: String, completion: @escaping (Bool) -> ()) {
        let booking = Booking(id: resID, resID: resID, username: userID)
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
    
    func listBookings(userID: String, completion: @escaping ([Booking]) -> ()) {
        let booking = Booking.keys
        let predicate = booking.username == userID
        Amplify.API.query(request: .paginatedList(Booking.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let bookings):
                    print("Successfully retrieved list of todos: \(bookings)")
                    let array = Array(bookings)
                    completion(array)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                    completion([])
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
                completion([])
            }
        }
    }
}
