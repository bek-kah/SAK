import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // Dependencies
    private let healthStore = HealthStore()
    @State private var showNewWorkout: Bool = false
    @State private var selectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
    
    var selectedDateText: String {
        let selectedDate = getSelectedDate(selectedDay)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        NavigationStack {
            DashboardView(healthStore: healthStore, selectedDay: $selectedDay)
                .navigationTitle("Fit-tick")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Text(selectedDateText)
                                .font(.system(size: 15, weight: .medium))
                                .fontWidth(.expanded)
                                .foregroundStyle(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showNewWorkout = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .sheet(isPresented: $showNewWorkout) {
                            NewWorkoutView()
                        }
                    }
                }
        }
        .onAppear(perform: requestHealthKitAccess)
    }
}

// MARK: - ContentView Helpers
private extension ContentView {
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
