//
//  TextFieldUI.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-18.
//

import SwiftUI

struct TextFieldUI: View {
    @Binding var text: String
    @State var title: String
    @State var placeholder: String
    @State var keyboardType: UIKeyboardType = .default
    @State var isShowPasword: Bool = false
    @State var isPaswordField: Bool = false
    var disabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(Font.custom("Poppins-Regular", size: 14))
            if(isShowPasword){
                HStack {
                    SecureField(placeholder, text: $text)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .keyboardType(keyboardType)
                }.overlay(alignment: .trailing) {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color.black.opacity(0.7)).onTapGesture {
                            isShowPasword.toggle()
                        }.padding(.trailing, 12)
                }
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(disabled ? Color.black.opacity(0.4) : Color.black)
                    .disabled(disabled)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .keyboardType(keyboardType)
                    .overlay(alignment: .trailing) {
                        if(isPaswordField){
                            Image(systemName: "eye.fill")
                                .foregroundColor(Color.black.opacity(0.7)).onTapGesture {
                                    isShowPasword.toggle()
                                }.padding(.trailing, 12)
                        }
                    }
            }
        }
    }
}
