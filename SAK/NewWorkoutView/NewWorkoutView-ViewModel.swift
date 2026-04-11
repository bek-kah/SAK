import Foundation
import SwiftData

extension NewWorkoutView {
    @Observable
    class ViewModel {
        var name: String = ""
        var weekday: Int
        var exercises: [Exercise] = []
        var modelContext: ModelContext
        
        init(
            selectedDay: Int,
            modelContext: ModelContext
        ) {
            self.weekday = getWeekdayIndex(selectedDay)
            self.modelContext = modelContext
        }
        
        func createWorkout(completion: @escaping () -> Void) {
            let workout = Workout(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                weekday: weekday,
                exercises: exercises
            )
            modelContext.insert(workout)
            try? modelContext.save()
            completion()
        }
        
    }
}
