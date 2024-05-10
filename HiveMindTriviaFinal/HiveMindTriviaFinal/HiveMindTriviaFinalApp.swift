//
//  HiveMindTriviaFinalApp.swift
//  HiveMindTriviaFinal
//
//  Created by Sofia G. Cora on 4/25/24.
//

import SwiftUI
import Firebase
@main
struct TriviaFirebaseApp: App {
    @StateObject var dataManager = DataManager()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
