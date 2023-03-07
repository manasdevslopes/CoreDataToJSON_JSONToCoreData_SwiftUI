//
//  ContainerViewModel.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 06/03/23.
//

import SwiftUI
import CoreData

class ContainerViewModel: ObservableObject {
  @Published var purchaseItems: [Purchase] = []
  
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchData()
  }
}

extension ContainerViewModel {
  func fetchData() {
    let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Purchase.dateOfPurchase, ascending: false)]
    
    do {
      purchaseItems = try viewContext.fetch(request)
    } catch let error {
      print("Error fetching Data. \(error.localizedDescription)")
#if DEBUG
      assertionFailure()
#endif
    }
  }
  
  func saveData() {
    if viewContext.hasChanges {
      try? viewContext.save()
      fetchData()
    }
  }
  
  func addExpense(_ title: String, _ dateOfPurchase: Date, _ amount: Double) {
    let newItem = Purchase(context: viewContext)
    newItem.id = .init()
    newItem.title = title
    newItem.dateOfPurchase = dateOfPurchase
    newItem.amountSpent = amount
    saveData()
  }
  
  /// - Export CoreData to JSON
  func exportCoreDate() async throws -> URL? {
    do {
      /// - Step 1 - Fetch all data from CoreData
      let request: NSFetchRequest<Purchase> = Purchase.fetchRequest()
      let items = try viewContext.fetch(request).compactMap { $0 }
      print("ITEMS------>", items)
      
      /// - Step 2 - Converting Items to JSON String File
      let jsonData = try JSONEncoder().encode(items)
      let jsonString = String(data: jsonData, encoding: .utf8)!
      print("JSON string------>", jsonString)
      
      // Save the JSON string to a temporary file in the documents directory
      let fileName = "Export on \(Date().formatted(date: .complete, time: .omitted)).json"
      guard let tempDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return URL(string: "") }
      let fileURL = tempDirectoryURL.appendingPathComponent(fileName)
      try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
      
      // Return the URL to the saved file
      return fileURL
    } catch {
      print("EXPORT_COREDATA_To_JSON", error.localizedDescription)
      throw error
    }
  }
  
  func deleteTempFile(_ shareURL: URL) {
    do {
      try FileManager.default.removeItem(at: shareURL)
      print("Removed Temp JSON File")
    } catch {
      print("deleteTempFile---->", error.localizedDescription)
    }
  }
  
  func importJSONToCoreData(_ url: URL) async {
    print("importJSONToCoreData----->", url)
    do {
      let jsonData = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.userInfo[.context] = viewContext
      let decodedItems = try decoder.decode([Purchase].self, from: jsonData)
      print("decodedItems----->", decodedItems)
      await MainActor.run(body: {
        saveData()
      })
      
      print("File Imported Successfully")
    } catch {
      print("importJSONToCoreData_Error----->", error)
    }
  }
  
  /// Delete from CoreData
  func deleteObject(at offsets: IndexSet) {
    for index in offsets {
      let selectedObject = purchaseItems[index]
      viewContext.delete(selectedObject)
      saveData()
    }
  }
}
