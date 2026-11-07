import SwiftUI

@main
struct DivehiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .statusBarHidden()
                .persistentSystemOverlays(.hidden)
                // Edge swipes need a second swipe, so stray toddler swipes
                // don't pull down Control Center or leave the app.
                .defersSystemGestures(on: .all)
        }
    }
}
