import SwiftData
import SwiftUI

@main
struct SAKApp: App {
    init() {
        let appear = UINavigationBarAppearance()
        
        let largeTitleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(
                        ofSize: 24,
                        weight: .bold,
                        width: .expanded
                    )
                ]
        
        let titleAtters: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(
                        ofSize: 20,
                        weight: .bold,
                        width: .expanded
                    )
                ]
        
        appear.largeTitleTextAttributes = largeTitleAttrs
        appear.titleTextAttributes = titleAtters
        appear.backgroundColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Workout.self)
        }
    }
}
