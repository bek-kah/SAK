import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // Dependencies
    private let healthStore = HealthStore()
    @State private var showNewWorkout: Bool = false

    var body: some View {
        NavigationStack {
            DashboardView(healthStore: healthStore)
                .navigationTitle("Fit-tick")
                .toolbar { topBarMenu }
        }
        .onAppear(perform: requestHealthKitAccess)
    }
}

// MARK: - ContentView Helpers
private extension ContentView {
    var topBarMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("", systemImage: "plus") {
                showNewWorkout = true
            }
            .sheet(isPresented: $showNewWorkout) {
                NewWorkoutView()
            }
        }
    }
    
    func requestHealthKitAccess() {
        healthStore.requestAuthorization { success, error in
            if let error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization successful. Success: \(success)")
            }
        }
    }
}

#Preview {
    ContentView()
}
