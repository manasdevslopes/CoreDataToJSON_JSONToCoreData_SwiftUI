//
//  AddNewExpense.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 06/03/23.
//

import SwiftUI

struct AddNewExpense: View {
  @EnvironmentObject var vm: ContainerViewModel
  
  @State private var title: String = ""
  @State private var dateOfPurchase: Date = .init()
  @State private var amountSpent: Double = 0
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      List {
        Section("Purchase Item") {
          TextField("", text: $title)
        }
        
        Section("Date of Purchase") {
          DatePicker("", selection: $dateOfPurchase, displayedComponents: [.date]).labelsHidden()
        }
        
        Section("Amount Spent") {
          TextField(value: $amountSpent, formatter: currencyFormatter) {}
            .labelsHidden().keyboardType(.numberPad)
        }
      }
      .navigationTitle("New Expense")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") {
            vm.addExpense(title, dateOfPurchase, amountSpent)
            dismiss()
          }
        }
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
  }
}

struct AddNewExpense_Previews: PreviewProvider {
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    AddNewExpense()
      .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
  }
}


/// - Currency Number Formatter
let currencyFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.allowsFloats = false
  formatter.numberStyle = .currency
  return formatter
}()
