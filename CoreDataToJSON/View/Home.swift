//
//  Home.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 06/03/23.
//

import SwiftUI

struct Home: View {
  @EnvironmentObject var vm: ContainerViewModel
  @State private var addExpense: Bool = false
  
  @State private var presentShareSheet: Bool = false
  @State private var shareURL: URL = URL(string: "https://apple.com")!
  @State private var presentFilePicker: Bool = false
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(vm.purchaseItems) { purchase in
          HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
              Text(purchase.titleView)
                .fontWeight(.semibold)
              Text(purchase.dateView.toString("MMM dd, YYYY"))
                .font(.caption).foregroundColor(.gray)
            }
            Spacer(minLength: 0)
            Text(currencyFormatter.string(from: NSNumber(value: purchase.amountView)) ?? "")
              .fontWeight(.bold)
          }
        }
        .onDelete(perform: vm.deleteObject)
      }
      .toolbar {
        EditButton()
      }
      .listStyle(.insetGrouped)
      .navigationTitle("My Expenses")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            addExpense.toggle()
          } label: {
            Image(systemName: "plus")
          }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
          Menu {
            Button("Import") {
              presentFilePicker.toggle()
            }
            Button("Export") {
              Task {
                if let url = try await vm.exportCoreDate() {
                  shareURL = url
                  presentShareSheet.toggle()
                }
              }
            }
          } label: {
            Image(systemName: "ellipsis").rotationEffect(.init(degrees: -90))
          }
        }
      }
      .sheet(isPresented: $addExpense) {
        AddNewExpense()
          .presentationDetents([.medium]).presentationDragIndicator(.hidden).interactiveDismissDisabled()
      }
      .sheet(isPresented: $presentShareSheet) {
        vm.deleteTempFile(shareURL)
      } content: {
        CustomShareSheet(url: $shareURL)
      }
      .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.json]) { result in
        switch result {
          case .success(let success):
            if success.startAccessingSecurityScopedResource() {
              Task {
                await vm.importJSONToCoreData(success)
              }
            }
          case .failure(let failure):
            print(failure.localizedDescription)
        }
      }
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    Home()
      .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
  }
}

extension Date {
  func toString(_ format: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

struct CustomShareSheet: UIViewControllerRepresentable {
  @Binding var url: URL
  func makeUIViewController(context: Context) -> UIActivityViewController {
    return UIActivityViewController(activityItems: [url], applicationActivities: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
