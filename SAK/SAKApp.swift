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
                weight: .black,
                width: .expanded
            )
        ]
        
        appear.largeTitleTextAttributes = largeTitleAttrs
        appear.titleTextAttributes = titleAtters
        appear.backgroundColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
        
        do {
            container = try ModelContainer(for: Workout.self, WorkoutSession.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
    
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
                .modelContainer(for: [Workout.self, WorkoutSession.self])
        }
    }
}
