//
//  ForgotPassword.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct ForgotPassword: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var forgotPasswordVM = ForgotPasswordViewModel()
    
    @State private var errorMessage: String = ""
    @State private var isRequested: Bool = false
    @State private var isShowPassword: Bool = true
    @State private var isShowSuccessPopup: Bool = false
    
    private func formValidation() {
        errorMessage = ""
        if (!isValidEmail(forgotPasswordVM.email)) {
            self.errorMessage = "Invalid email!"
            return
        }
        if isRequested {
            if forgotPasswordVM.code.count < 4 {
                self.errorMessage = "Invalid code!"
            }
            if (!isValidPassword(forgotPasswordVM.password)) {
                self.errorMessage = "Invalid password!"
                return
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if forgotPasswordVM.isLoading {
                    Loading()
                }
                VStack(alignment: .leading) {
                    Text(!isRequested ? "Forgot your password!" : "Reset password")
                        .font(Font.custom("Poppins-Bold", size: 32))
                        .padding(.bottom, 1)
                    Text(!isRequested ? "Enter your registered email below to receive password reset code." : "Check email and enter recieved code with new password.")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color.black.opacity(0.75))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
                    VStack(alignment: .leading) {
                       
                        if(isRequested){
                            TextFieldUI(text: $forgotPasswordVM.code, title: "Reset Code", placeholder: "Enter code", keyboardType: .numberPad)
                            TextFieldUI(text: $forgotPasswordVM.password, title: "New password", placeholder: "Enter new password", keyboardType: .default, isShowPasword: isShowPassword, isPaswordField: true)
                        } else {
                            TextFieldUI(text: $forgotPasswordVM.email, title: "Email", placeholder: "Your email", keyboardType: .emailAddress, disabled: self.isRequested)
                        }
                    }.padding(.vertical, 16)
                    Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13))
                    ButtonUI(title: !isRequested ? "Send code" : "Reset password") {
                        formValidation()
                        if errorMessage.isEmpty {
                            if !isRequested {
                                forgotPasswordVM.forgotPassword { success, message in
                                    if(success) {
                                        self.isRequested = true
                                    } else {
                                        self.errorMessage = (message ?? message)!
                                    }
                                }
                            } else {
                                forgotPasswordVM.resetPassword { success, message in
                                    if (success) {
                                        self.isShowSuccessPopup = true
                                    } else {
                                        self.errorMessage = (message ?? message)!
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Back to")
                            .font(Font.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color.black.opacity(0.6))
                        Button("Sign in.", action: {
                            self.presentationMode.wrappedValue.dismiss()
                            forgotPasswordVM.email = ""
                            forgotPasswordVM.code = ""
                            forgotPasswordVM.password = ""
                        })
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(Color(hex: "#6C0EB7"))
                    }.frame(maxWidth: .infinity).padding(.all, 10)
                }.padding(20).navigationBarHidden(true)
                
                if isShowSuccessPopup {
                    Dialog(status: $isShowSuccessPopup, title: "Password reset success!", decription: "Now you can login your account with new password.", action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            }.navigationBarHidden(true)
        }.navigationBarHidden(true)
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
