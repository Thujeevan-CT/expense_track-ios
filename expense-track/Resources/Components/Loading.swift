//
//  Loading.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-25.
//

import SwiftUI

struct Loading: View {
    @State private var offset: CGFloat = 1000
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack{
            Color(.black).opacity(0.7)
            VStack {
                ZStack {
                    Circle()
                        .stroke (lineWidth: 8) .opacity (0.3)
                        .foregroundColor(Color(hex: "#6300E0"))
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke (style: StrokeStyle (lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color(hex: "#6C0EB7"))
                        .rotationEffect(.degrees (rotation)).animation(.linear (duration:1)
                        .repeatForever(autoreverses: false), value: rotation)
                        .onAppear {
                            self.rotation = 360
                        }
                }.frame(width: 60)
                Text("Please wait...")
                    .font(Font.custom("Poppins-Regular", size: 18))
                    .padding(.top, 20)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(EdgeInsets(top: 30, leading: 40, bottom: 30, trailing: 40))
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 20)
            .padding(30)
        } .ignoresSafeArea().zIndex(10000)
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
