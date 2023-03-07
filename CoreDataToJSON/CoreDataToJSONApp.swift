//
//  CoreDataToJSONApp.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 06/03/23.
//

import SwiftUI

@main
struct CoreDataToJSONApp: App {
  let persistenceController = PersistenceController.shared
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
        }
    }
}
