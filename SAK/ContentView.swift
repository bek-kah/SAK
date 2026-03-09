import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // Dependencies
    private let healthStore = HealthStore()
    @State private var selectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
    
    @State private var showNewWorkoutView: Bool = false
    @State private var showNewWeightView: Bool = false
    
    @State private var refresh = false
    
    var selectedDateText: String {
        let selectedDate = getSelectedDate(selectedDay)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        NavigationStack {
            DashboardView(
                healthStore: healthStore,
                selectedDay: $selectedDay,
                refresh: refresh
            )
            .navigationTitle("Fit-tick")
            .sheet(isPresented: $showNewWorkoutView) {
                NewWorkoutView(selectedDay: selectedDay)
            }
            .sheet(isPresented: $showNewWeightView) {
                NewWeightView {
                    refresh.toggle()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(selectedDateText) {
                        Button("Today", systemImage: "location.fill") {
                            selectedDay = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
                        }
                        Button("Select Date", systemImage: "calendar") {}
                    }
                    .font(.system(size: 15, weight: .medium))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                }
                
                ToolbarSpacer(placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("", systemImage: "plus") {
                        Button("Add Workout", systemImage: "figure.strengthtraining.traditional") {
                            showNewWorkoutView = true
                        }
                        Button("Record Weight", systemImage: "figure") {
                            showNewWeightView = true
                        }
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
