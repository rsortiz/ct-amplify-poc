//
//  MyBookingsView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI

struct MyBookingsView: View {
    
    @State var userID: String
    @State var bookings: [Booking] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Text("My Bookings")
            List {
                ForEach(bookings, id: \.resID) { booking in
                    Text(booking.resID)
                }
            }
        }
        .onAppear() {
            BookingService().listBookings(userID: userID) { bookings in
                self.bookings = bookings
            }
        }
    }
}

struct MyBookingsView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookingsView(userID: "")
    }
}
