//
//  Profile.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI
import Shimmer

struct Profile: View {
    @ObservedObject var profileVM = ProfileViewModel()
    @State private var isEdit = false
    @State private var errorMessage: String = ""
    @State private var isShowSuccessPopup: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // for temprory
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    private func formValidation() {
        self.errorMessage = ""
        if (profileVM.firstName.count < 3 || profileVM.lastName.count < 3) {
            self.errorMessage = "Name must be greater than 3 characters!"
            return
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Profile").font(Font.custom("Poppins-SemiBold", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextFieldUI(text: $profileVM.firstName, title: "First Name", placeholder: "Enter first name", disabled: !isEdit)
                        .shimmering(active: profileVM.isLoading)
                    TextFieldUI(text: $profileVM.lastName, title: "Last Name", placeholder: "Enter last name", disabled: !isEdit)
                        .shimmering(active: profileVM.isLoading)
                    TextFieldUI(text: $profileVM.email, title: "Email", placeholder: "Enter email", disabled: true)
                        .shimmering(active: profileVM.isLoading)
                    Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13)).padding(.top, 5)
                    if !profileVM.isLoading {
                        VStack {
                            Button {
                                if !isEdit {
                                    self.isEdit.toggle()
                                    self.firstName = profileVM.firstName
                                    self.lastName = profileVM.lastName
                                } else {
                                    formValidation()
                                    if errorMessage.isEmpty {
                                        profileVM.updateProfile{ success, message in
                                            if (success) {
                                                self.isShowSuccessPopup = true
                                            } else {
                                                self.errorMessage = (message ?? message)!
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Text(isEdit ? "SAVE" : "EDIT")
                                    .font(Font.custom("Poppins-SemiBold", size: 16))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .frame( minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50 )
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#6300E0"), Color(hex: "#6C0EB7")]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(10)
                            }.padding(.top, 20)
                            Button {
                                if !isEdit {
                                    UserDefaults.standard.removeObject(forKey: Constants.jwtToken)
                                    UserDefaults.standard.removeObject(forKey: Constants.userID)
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    profileVM.firstName = self.firstName
                                    profileVM.lastName = self.lastName
                                    self.isEdit.toggle()
                                }
                            } label: {
                                Text(isEdit ? "CANCEL" : "LOGOUT")
                                    .font(Font.custom("Poppins-SemiBold", size:16))
                                    .foregroundColor(Color(hex: "#c6002e"))
                                    .multilineTextAlignment(.center)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50 )
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            .shadow(color: .gray.opacity(0.5), radius: 20, x: 0, y: 0)
                            .padding(.top, 15)
                        }
                    }
                }
                Spacer()
            }
            .padding(20)
            .onDisappear {
                self.isEdit = false
            }
            .onAppear {
                profileVM.getProfile { success, message in }
            }
            if isShowSuccessPopup {
                Dialog(status: $isShowSuccessPopup, title: "Profile updated.", action: { })
            }
        }
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
