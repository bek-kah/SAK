import Foundation
import SwiftData

@Model
class Workout {
    var id: UUID
    var name: String
    var weekday: Int
    var exercises: [Exercise]
    var sortedExercises: [Exercise] {
        exercises.sorted(by: { $0.position < $1.position })
    }
    
    init(name: String, weekday: Int, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.weekday = weekday
        self.exercises = exercises
    }
    
    static func fake(_ weekday: Int) -> Workout {
        return Workout(
            name: "Chest Day",
            weekday: weekday,
            exercises: [
                Exercise(name: "Push-ups", position: 0),
                Exercise(name: "Bench Press", position: 1),
                Exercise(name: "Fly", position: 2)
            ])
    }
}

@Model
class Exercise {
    var id: UUID
    var name: String
    var position: Int
    
    init(name: String, position: Int) {
        self.id = UUID()
        self.name = name
        self.position = position
    }
}

@Model
class WorkoutSession {
    var id: UUID
    var workoutID: UUID
    var date: Date
    var completions: [ExerciseCompletion] = []
    
    init(
        workoutID: UUID,
        date: Date
    ) {
        self.id = UUID()
        self.workoutID = workoutID
        self.date = date
    }
    
    static func fake(_ weekday: Int) -> WorkoutSession {
        let workout = Workout.fake(weekday)
        let session = WorkoutSession(workoutID: workout.id, date: Date())
        session.completions = workout.exercises
            .sorted { $0.position < $1.position }
            .map { ExerciseCompletion(exerciseID: $0.id) }
        
        return session
    }
}

@Model
class ExerciseCompletion {
    var id: UUID
    var exerciseID: UUID
    var isComplete: Bool
    
    init(
        exerciseID: UUID,
    ) {
        self.id = UUID()
        self.exerciseID = exerciseID
        self.isComplete = false
    }
}

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
