import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // Dependencies
    private let healthStore = HealthStore()
    @State private var selectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
    @State private var currentWeekIndex: Int? = 52
    
    @State private var selectedDate = Date()
    
    @State private var showNewWorkoutView: Bool = false
    @State private var showNewWeightView: Bool = false
    @State private var showDatePicker: Bool = false
    
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
                currentWeekIndex: $currentWeekIndex,
                refresh: refresh,
            )
            .navigationTitle("fit-tick")
            .sheet(isPresented: $showDatePicker) {
                DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .presentationDetents([.medium])
                    .padding()
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
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
                            currentWeekIndex = 52
                        }
                        Button("Select Date", systemImage: "calendar") {
                            showDatePicker = true
                        }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                }
                
                ToolbarSpacer(placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("", systemImage: "plus") {
                        Button("New Workout", systemImage: "figure.strengthtraining.traditional") {
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
        .onChange(of: selectedDate) { _, newDate in
            withAnimation {
                selectedDay = getSelectedDay(newDate)
                currentWeekIndex = selectedDay / 7
            }
        }
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
