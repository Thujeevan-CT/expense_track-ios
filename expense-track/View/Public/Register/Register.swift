//
//  Register.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct Register: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var registerVM = RegistrationViewModel()
    
    @State private var alertMessage: String = ""
    @State private var errorMessage: String = ""
    
    @State private var isShowPassword: Bool = true
    @State private var isShowSuccessPopup: Bool = false
    
    private func formValidation() {
        self.errorMessage = ""
        if (registerVM.firstName.count < 3 || registerVM.lastName.count < 3) {
            self.errorMessage = "Name must be greater than 3 characters!"
            return
        } else if (!isValidEmail(registerVM.email)) {
            self.errorMessage = "Invalid email!"
            return
        } else if (!isValidPassword(registerVM.password)) {
            self.errorMessage = "Invalid password!"
            return
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if registerVM.isLoading {
                    Loading()
                }
                VStack(alignment: .leading) {
                    Text("Begin Here!")
                        .font(Font.custom("Poppins-Bold", size: 36))
                    Text("Plan your financial future today.")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Color.black.opacity(0.75))
                    VStack(alignment: .leading) {
                        TextFieldUI(text: $registerVM.firstName, title: "First name", placeholder: "Your first name", keyboardType: .default)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.01)
                        TextFieldUI(text: $registerVM.lastName, title: "Last name", placeholder: "Your last name", keyboardType: .default)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.01)
                        TextFieldUI(text: $registerVM.email, title: "Email", placeholder: "Your email", keyboardType: .emailAddress)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.01)
                        TextFieldUI(text: $registerVM.password, title: "Password", placeholder: "Your password", keyboardType: .default, isShowPasword: isShowPassword, isPaswordField: true)
                    }.padding(.vertical, 16)
                    Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13))
                    ButtonUI(title: "Register") {
                        formValidation()
                        if errorMessage.isEmpty {
                            registerVM.registerUser { success, message in
                                if (success) {
                                    self.isShowSuccessPopup = true
                                } else {
                                    self.errorMessage = (message ?? message)!
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Already have an account?")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color.black.opacity(0.6))
                        Button("Sign in.", action: {
                            self.presentationMode.wrappedValue.dismiss()
                            registerVM.email = ""
                            registerVM.firstName = ""
                            registerVM.lastName = ""
                            registerVM.password = ""
                        })
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(hex: "#6C0EB7"))
                    }.frame(maxWidth: .infinity).padding(.all, 10)
                }.padding(20)
                if isShowSuccessPopup {
                    Dialog(status: $isShowSuccessPopup, title: "Registraiton success!", decription: "Now you can login your account.", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
