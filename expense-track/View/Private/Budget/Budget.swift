//
//  Budget.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-28.
//

import SwiftUI
import Shimmer

struct Budget: View {
    @ObservedObject var expenseCategoryViewModel = ExpenseCategoryViewModel()
    @ObservedObject var budgetVM = BudgetViewModel()
    
    @State private var isDataFetched = false
    @State private var showBottomSheet: Bool = false
    @State private var selectedCategoryIndex = 0
    @State private var selectedPeriodIndex = 0
    @State private var errorMessage: String = ""
    
    let categories = [
        PeriodCategory(name: "Weekly", key: "weekly"),
        PeriodCategory(name: "Monthly", key: "monthly"),
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                HStack {
                    Text("Budgets").font(Font.custom("Poppins-SemiBold", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        self.showBottomSheet.toggle()
                    } label: {
                        Image(systemName: "plus.app")
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: "#6C0EB7"))
                            .frame(width: 35, height: 35)
                    }
                }
                if budgetVM.isLoading {
                    CardLoading(status: $budgetVM.isLoading)
                } else {
                    VStack {
                        ForEach(0..<budgetVM.budgets.count, id: \.self) { index in
                            VStack {
                                HStack{
                                    Text(String(budgetVM.budgets[index].budget_type).uppercased()).frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Rs " + String(budgetVM.budgets[index].amount) + ".00")
                                }.frame(maxWidth: .infinity).padding(.bottom, 5)
                                HStack{
                                    Text(String(budgetVM.budgets[index].start_date)).frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(budgetVM.budgets[index].end_date))
                                }.frame(maxWidth: .infinity)
                            }
                            .padding(.all, 10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.top, 10)
                            .shadow(color: Color.black.opacity(0.13), radius: 20, x: 0, y: 0)
                        }
                    }.frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .sheet(isPresented: $showBottomSheet) {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        Text("Add budget").font(Font.custom("Poppins-SemiBold", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            HStack {
                                Text("Select a category:")
                                    .font(Font.custom("Poppins-Regular", size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker(selection: $selectedCategoryIndex, label: Text("Category")) {
                                    ForEach(0..<expenseCategoryViewModel.expenseCategories.count, id: \.self) { index in
                                        Text(expenseCategoryViewModel.expenseCategories[index].name)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle()).accentColor(Color(hex: "#6C0EB7"))
                            }.frame(maxWidth: .infinity)
                            HStack {
                                Text("Select period:")
                                    .font(Font.custom("Poppins-Regular", size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker(selection: $selectedPeriodIndex, label: Text("Category")) {
                                    ForEach(0..<categories.count, id: \.self) { index in
                                        Text(categories[index].name)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle()).accentColor(Color(hex: "#6C0EB7"))
                            }
                            TextFieldUI(text: $budgetVM.amount, title: "Amount", placeholder: "Enter expense amount", keyboardType: .numberPad)
                            Text(errorMessage.isEmpty ? "" : errorMessage).foregroundColor(Color.red).font(Font.custom("Poppins-regular", size: 13)).padding(.top, 5)
                            ButtonUI(title: "Save") {
                                errorMessage = ""
                                budgetVM.categoryID = expenseCategoryViewModel.expenseCategories[selectedCategoryIndex].id
                                budgetVM.budgetType = categories[selectedPeriodIndex].key
                                budgetVM.addBudget { success, message in
                                    if (success) {
                                        budgetVM.fetchBudgets { _,_ in }
                                        self.showBottomSheet.toggle()
                                    } else {
                                        self.errorMessage = (message ?? message)!
                                    }
                                }
                            }.shimmering(active: budgetVM.isLoading)
                        }.padding(.top, 10)
                    }
                }.padding(20)
            }
        }
        .onAppear {
            expenseCategoryViewModel.fetchCategories()
            budgetVM.fetchBudgets { _,_ in }
        }
        .onDisappear {
            errorMessage = ""
        }
    }
}

struct PeriodCategory {
    let name: String
    let key: String
}

struct Budget_Previews: PreviewProvider {
    static var previews: some View {
        Budget()
    }
}
