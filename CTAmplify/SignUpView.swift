//
//  SignUpView.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 27/04/2023.
//

import SwiftUI

struct SignUpView: View {
    
    @Binding var shouldPopToRootView : Bool
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var showingAlert = false
    @State var showingConfirmation = false
    
    @State var alertTitle = ""
    @State var alertText = ""
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
            }
            
            VStack {
                CTButton(title: "Sign up",
                         action: {
                    
                    if (username.count < 1) {
                        alertTitle = "Error"
                        alertText = "Please fill the username field"
                        showingAlert = true
                        return
                    }
                    
                    if (email.count < 1) {
                        alertTitle = "Error"
                        alertText = "Please fill the email field"
                        showingAlert = true
                        return
                    }
                    
                    if (password.count < 1) {
                        alertTitle = "Error"
                        alertText = "Please fill the password field"
                        showingAlert = true
                        return
                    }
                    
                    Task {
                        AuthService().signUp(username:username, password:password, email:email) { success, errorDescription in
                            if success {
                                showingConfirmation = true
                            } else {
                                alertTitle = "Error"
                                alertText = "It was not possible to create the registration"
                                if let error = errorDescription {
                                    alertText = "\(alertText): \(error)"
                                }
                                
                                showingAlert = true
                            }
                        }
                    }
                }, buttonColor: .blue)
            }
            .alert(isPresented: $showingAlert, content: { () -> Alert in
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertText),
                    dismissButton: .default(Text("OK")))
            })
            
            NavigationLink(destination: ConfirmSignUpView(shouldPopToRootView: $shouldPopToRootView, username: username), isActive: $showingConfirmation) {
                EmptyView()
            }
        }
        .padding(16)
        .navigationBarTitle(Text("Sign up"))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

struct ConfirmSignUpView: View {
    
    enum FocusField: Hashable {
        case field
    }
    
    @Binding var shouldPopToRootView : Bool
    
    @State var username: String
    @State var confirmationCode: String = ""
    @State var showingAlert = false
    
    @State var alertTitle = ""
    @State var alertText = ""
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                TextField("Confirmation code", text: $confirmationCode)
                    .autocapitalization(.none)
                    .autocorrectionDisabled(true)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(.gray)))
                    .focused($focusedField, equals: .field)
            }
            
            VStack {
                CTButton(title: "Confirm",
                         action: {
                    if (confirmationCode.count < 1) {
                        alertTitle = "Error"
                        alertText = "Please fill the confirmation code field."
                        showingAlert = true
                        return
                    }
                    
                    AuthService().confirmSignUp(for: username, with: confirmationCode) { success, errorDescription in
                        if success {
                            alertTitle = "Success"
                            alertText = "Resgistration confirmated with success."
                            shouldPopToRootView = false
                        } else {
                            alertTitle = "Error"
                            alertText = "It was not possible to create the registration."
                            if let error = errorDescription {
                                alertText = "\(alertText): \(error)"
                            }
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
        .navigationBarTitle(Text("Confirm"))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(shouldPopToRootView: .constant(false))
    }
}
