import SwiftData
import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedWeekday: Int = 0
    
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = .current
        let symbols = formatter.weekdaySymbols
        if let symbols = symbols, symbols.isEmpty == false {
            return symbols
        } else {
            return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        }
    }
    
    var body: some View {
        Picker("Day", selection: $selectedWeekday) {
            ForEach(0..<weekdays.count, id: \.self) {
                Text(weekdays[$0])
            }
        }
        Button("Create Workout") {
            modelContext.insert(Workout.fake(weekdays[selectedWeekday]))
            dismiss()
        }
    }
}
