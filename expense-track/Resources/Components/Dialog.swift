//
//  Dialog.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-25.
//

import SwiftUI

struct Dialog: View {
    @Binding var status: Bool
    var title: String = "Success"
    var decription: String = ""
    var buttontext: String = "Ok"
    let action: () -> ()
    @State private var offset: CGFloat = 1000
    
    func onClose() {
        withAnimation(.spring()) {
            offset = 1000
            status = false
        }
    }
    
    var body: some View {
        ZStack{
            Color(.black).opacity(0.48)
            VStack {
                Text(title).font(Font.custom("Poppins-Bold", size: 22))
                if(decription.count >= 1) {
                    Text(decription).font(Font.custom("Poppins-Regular", size: 14)).padding(EdgeInsets(top: 0.5, leading: 0, bottom: 10, trailing: 0)).multilineTextAlignment(.center)
                }
                ButtonUI(title: buttontext) {
                    action()
                    onClose()
                }.padding(.top, 12)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 25, leading: 20, bottom: 25, trailing: 20))
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }.ignoresSafeArea().zIndex(10000)
    }
}

struct Dialog_Previews: PreviewProvider {
    static var previews: some View {
        Dialog(status: .constant(true), title: "Registraion success", decription: "You can login your account.", action: {})
    }
}
