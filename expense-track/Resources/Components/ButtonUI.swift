//
//  ButtonUI.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-17.
//

import SwiftUI

struct ButtonUI: View {
    @State var title: String = "Title"
    var onClick: (()->())?
    
    var body: some View {
        Button {
            onClick?()
        } label: {
            Text(title)
                .font(Font.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame( minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50 )
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#6300E0"), Color(hex: "#6C0EB7")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
        }
        
    }
}

struct ButtonUI_Previews: PreviewProvider {
    static var previews: some View {
        ButtonUI().padding(20)
    }
}
