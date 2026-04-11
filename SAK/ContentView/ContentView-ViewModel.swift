import Foundation
import SwiftData

extension ContentView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var selectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
        var currentWeekIndex: Int? = 52
        var selectedDate: Date = Date()
        var showNewWorkoutView: Bool = false
        var showNewWeightView: Bool = false
        var showDatePicker: Bool = false
        var refresh: Bool = false
        
        let healthStore = HealthStore()
        
        var selectedDateText: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            return formatter.string(from: selectedDate)
        }
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
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
        
        func goToToday() {
            selectedDay = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
            currentWeekIndex = 52
        }
        
        func onDateChanged(_ newDate: Date) {
            selectedDay = getSelectedDay(newDate)
            currentWeekIndex = selectedDay / 7
        }
    }
}
