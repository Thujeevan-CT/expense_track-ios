//
//  CardLoading.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-30.
//

import SwiftUI
import Shimmer

struct CardLoading: View {
    @Binding var status: Bool
    
    var body: some View {
        VStack {
            HStack{
                Text("Weekly").frame(maxWidth: .infinity, alignment: .leading)
                Text("Rs 0.00")
            }.frame(maxWidth: .infinity).padding(.bottom, 5)
            HStack{
                Text("29/09/2023").frame(maxWidth: .infinity, alignment: .leading)
                Text("08/10/2023")
            }.frame(maxWidth: .infinity)
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
        .padding(.top, 10)
        .shimmering(active: status)
        VStack {
            HStack{
                Text("Weekly").frame(maxWidth: .infinity, alignment: .leading)
                Text("Rs 0.00")
            }.frame(maxWidth: .infinity).padding(.bottom, 5)
            HStack{
                Text("29/09/2023").frame(maxWidth: .infinity, alignment: .leading)
                Text("08/10/2023")
            }.frame(maxWidth: .infinity)
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
        .padding(.top, 10)
        .shimmering(active: status)
        VStack {
            HStack{
                Text("Weekly").frame(maxWidth: .infinity, alignment: .leading)
                Text("Rs 0.00")
            }.frame(maxWidth: .infinity).padding(.bottom, 5)
            HStack{
                Text("29/09/2023").frame(maxWidth: .infinity, alignment: .leading)
                Text("08/10/2023")
            }.frame(maxWidth: .infinity)
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
        .padding(.top, 10)
        .shimmering(active: status)
        VStack {
            HStack{
                Text("Weekly").frame(maxWidth: .infinity, alignment: .leading)
                Text("Rs 0.00")
            }.frame(maxWidth: .infinity).padding(.bottom, 5)
            HStack{
                Text("29/09/2023").frame(maxWidth: .infinity, alignment: .leading)
                Text("08/10/2023")
            }.frame(maxWidth: .infinity)
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
        .padding(.top, 10)
        .shimmering(active: status)
    }
}

#Preview {
    CardLoading(status: .constant(true))
}
