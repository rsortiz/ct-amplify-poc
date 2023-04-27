//
//  ContentView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var userID: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State private var showSignUpView = false
    @State private var showAddBooking = false
    @State private var showingAlert = false
    
    @State private var showingForm = false
    @State private var showingLoggedIn = false
    
    @State var alertTitle = ""
    @State var alertText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if showingLoggedIn {
                    Text("You're logged in!")
                    
                    CTButton(title: "My Bookings",
                             action: {
                    }, buttonColor: .blue)
                    
                    CTButton(title: "Add booking",
                             action: {
                        showAddBooking = true
                    }, buttonColor: .blue)
                    
                    NavigationLink(destination: AddBookingView(userID: userID), isActive: $showAddBooking) {
                        EmptyView()
                    }
                    
                    CTButton(title: "Logout",
                             action: {
                        AuthService().signOutGlobally { success, errorDescription in
                            self.displayForm(true)
                        }
                    }, buttonColor: .blue)
                } else if showingForm {
                    Text("Amplify POC")
                    VStack(spacing: 8) {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                    }
                    CTButton(title: "Sign In",
                             action: {
                        Task {
                            try await AuthService().signIn(username: username, password: password, completion: { success, info in
                                if success,
                                   let info = info {
                                    alertTitle = "Success"
                                    alertText = "Logged successfully"
                                    self.userID = info
                                    self.displayForm(false)
                                } else {
                                    alertTitle = "Error"
                                    alertText = "It was not possible to login"
                                    if let error = info {
                                        alertText = "\(alertText): \(error)"
                                    }
                                }
                                
                                showingAlert = true
                            })
                        }
                    }, buttonColor: .orange)
                    
                    NavigationLink(destination: SignUpView(shouldPopToRootView: $showSignUpView), isActive: $showSignUpView) {
                        EmptyView()
                    }
                    
                    CTButton(title: "Sign up",
                             action: {
                        showSignUpView = true
                    }, buttonColor: .blue)
                }
            }
            .alert(isPresented: $showingAlert, content: { () -> Alert in
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertText),
                    dismissButton: .default(Text("OK")))
            })
            .padding()
        }
        .onAppear() {
            AuthService().isUserLoggedIn { success, userID in
                if success, let userID = userID {
                    self.userID = userID
                    self.displayForm(false)
                } else {
                    self.displayForm(true)
                }
                
            }
        }
    }
    
    func displayForm(_ display: Bool) {
        if display {
            showingLoggedIn = false
            showingForm = true
        } else {
            showingLoggedIn = true
            showingForm = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
