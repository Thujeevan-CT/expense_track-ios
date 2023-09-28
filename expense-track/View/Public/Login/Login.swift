//
//  Login.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @State var isShowPassword: Bool = true
    @State private var errorMessage: String = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private func formValidation() {
        self.errorMessage = ""
        if (!isValidEmail(loginVM.email)) {
            self.errorMessage = "Invalid email!"
            return
        } else if (loginVM.password.count < 8) {
            self.errorMessage = "Password must be 8 characters!"
            return
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if loginVM.isLoading {
                    Loading()
                }
                VStack(alignment: .leading) {
                    Text("Start Exploring!")
                        .font(Font.custom("Poppins-Bold", size: 36))
                    Text("Financial discipline leads to financial success.")
                        .font(Font.custom("Poppins-Regular", size: 12))
                        .foregroundColor(Color.black.opacity(0.75))
                    VStack(alignment: .leading) {
                        TextFieldUI(text: $loginVM.email, title: "Email", placeholder: "Your email", keyboardType: .emailAddress)
                            .padding(.bottom, UIScreen.main.bounds.width * 0.01)
                        TextFieldUI(text: $loginVM.password, title: "Password", placeholder: "Your password", keyboardType: .default, isShowPasword: isShowPassword, isPaswordField: true)
                    }.padding(.vertical, 16)
                    NavigationLink(destination: ForgotPassword()) {
                        Text("Forgot Password?")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color(hex: "#6C0EB7"))
                    }
                    Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13))
                    ButtonUI(title: "Login") {
                        formValidation()
                        if errorMessage.isEmpty {
                            loginVM.login { success, message in
                                if (success) {
                                     self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.errorMessage = (message ?? message)!
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Don't have an account?")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color.black.opacity(0.6))
                        NavigationLink(destination: Register()) {
                            Text("Sign up.")
                                .font(.custom("Poppins-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#6C0EB7"))
                        }
                    }.frame(maxWidth: .infinity).padding(.all, 10)
                }.padding(20).navigationBarHidden(true)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
