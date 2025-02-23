import SwiftUI

@main
struct JuggleApp: App {
    @StateObject private var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
