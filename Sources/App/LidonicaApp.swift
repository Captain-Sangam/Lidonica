import SwiftUI

@main
struct LidonicaApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 680, minHeight: 560)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 780, height: 620)
    }
}
