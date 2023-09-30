//
//  Dashboard.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI
import Shimmer


struct Dashboard: View {
    @ObservedObject var StatsVM = StatsViewModel()
    @State private var selectedDuration: DurationOptions = .weekly
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                Text("My wallet").font(Font.custom("Poppins-SemiBold", size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ExpenseCardView().shimmering(active: StatsVM.isLoading)
                
                Picker("Choose a duration", selection: $selectedDuration) {
                    ForEach(DurationOptions.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                PieChart(
                    values: StatsVM.expensePercentages.map(\.percentage), 
                    names: StatsVM.expensePercentages.map(\.category_name),
                    colors : [.red, .orange, .yellow, .green, .cyan, .blue, .purple]
                ).shimmering(active: StatsVM.isLoading)

            }
            .padding(20)
            .onAppear {
                StatsVM.fetchStats(durationType: selectedDuration.rawValue.lowercased())
            }
            .onChange(of: selectedDuration) { newDuration in
                StatsVM.fetchStats(durationType: newDuration.rawValue.lowercased())
            }
        }
    }
    
    @ViewBuilder
    func ExpenseCardView() -> some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        Color(hex: "#6C0EB7"),
                        Color(hex: "#6300E0"),
                        Color(hex: "#6C0EB7"),
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    Text("Total Balance").font(Font.custom("Poppins-SemiBold", size: 24)).opacity(0.7)
                    Text("Rs \(StatsVM.currentCash).00").font(Font.custom("Poppins-SemiBold", size: 32))
                }.foregroundColor(.white)
                HStack(spacing: 15) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(Color.green)
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.3), in: Circle())
                    VStack(alignment: .leading, spacing: 4){
                        Text("Income").font(Font.custom("Poppins-SemiBold", size: 12)).opacity(0.7)
                        Text("Rs \(StatsVM.incomeAmount).00").font(Font.custom("Poppins-SemiBold", size: 12)).lineLimit(1).fixedSize()
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "arrow.up")
                        .foregroundColor(Color.red)
                        .frame(width: 30, height: 30)
                        .background(.white.opacity(0.3), in: Circle())
                    VStack(alignment: .leading, spacing: 4){
                        Text("Expense").font(Font.custom("Poppins-SemiBold", size: 12)).opacity(0.7)
                        Text("Rs \(StatsVM.expenseAmount).00").font(Font.custom("Poppins-SemiBold", size: 12)).lineLimit(1).fixedSize()
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical)
                .offset(y: 15)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 220)
        .padding(.top)
    }
}

enum DurationOptions: String, CaseIterable {
    case day = "DAY"
    case weekly = "WEEK"
    case monthly = "MONTH"
}


struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
