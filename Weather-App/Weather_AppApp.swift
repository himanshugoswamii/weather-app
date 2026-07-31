//
//  Weather_AppApp.swift
//  Weather-App
//
//  Created by Himanshu Goswami on 7/28/26.
//

import SwiftUI
import CoreData

@main
struct Weather_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeatherView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
