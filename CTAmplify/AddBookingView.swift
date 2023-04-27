//
//  AddBookingView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI
import Combine

struct AddBookingView: View {
    
    enum FocusField: Hashable {
        case field
    }
    
    @State var userID: String
    @State var bookingID: String = ""
    @State var showingAlert = false
    
    @State var alertTitle = ""
    @State var alertText = ""
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                TextField("Booking Number", text: $bookingID)
                    .autocorrectionDisabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                    .focused($focusedField, equals: .field)
                    .autocapitalization(.allCharacters)
                    .onReceive(Just(bookingID)) { inputValue in
                        if inputValue.count > 11 {
                            self.bookingID.removeLast()
                        }
                    }
            }
            
            VStack {
                CTButton(title: "Add booking",
                         action: {
                    if (bookingID.count < 1) {
                        alertTitle = "Error"
                        alertText = "Please fill the booking ID field."
                        showingAlert = true
                        return
                    }
                    
                    BookingService().createBooking(resID: bookingID, userID: userID) { success in
                        if success {
                            alertTitle = "Success"
                            alertText = "Booking added with success."
                        } else {
                            alertTitle = "Error"
                            alertText = "Booking has not been added"
                        }

                        showingAlert = true
                    }
                }, buttonColor: .blue)
            }
            .alert(isPresented: $showingAlert, content: { () -> Alert in
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertText),
                    dismissButton: .default(Text("OK")))
            })
            
        }
        .onAppear {
            self.focusedField = .field
        }
        .padding(16)
        .navigationBarTitle(Text("Add booking"))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

struct AddBookingView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookingView(userID: "")
    }
}
