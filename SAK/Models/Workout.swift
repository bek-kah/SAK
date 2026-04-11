import Foundation
import SwiftData

/// Arrays saved to SwiftData don't maintain their order, which is why Exercise and ExerciseCompletion have a position variable that Workout and WorkoutSession use to compute sortedExercises and sortedCompletions.
/// It's crucial that each elements of Arrays with position variables are properly updated when they are those Arrays are changed. [Deletion, Insertion, Change of Order]

@Model
class Workout {
    var id: UUID
    var name: String
    var weekday: Int
    var dateCreated: Date
    var exercises: [Exercise]
    var sortedExercises: [Exercise] {
        exercises.sorted(by: { $0.position < $1.position })
    }
    
    init(name: String, weekday: Int, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.weekday = weekday
        self.dateCreated = Date()
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
class Exercise: Equatable {
    var id: UUID
    var name: String
    var position: Int
    
    init(name: String, position: Int) {
        self.id = UUID()
        self.name = name
        self.position = position
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.position == rhs.position && lhs.name == rhs.name
    }
}

@Model
class WorkoutSession {
    var id: UUID
    var workoutID: UUID
    var name: String
    var date: Date
    var completions: [ExerciseCompletion] = []
    var sortedCompletions: [ExerciseCompletion] {
        completions.sorted(by: { $0.position < $1.position })
    }
    
    init(
        workoutID: UUID,
        name: String,
        date: Date
    ) {
        self.id = UUID()
        self.name = name
        self.workoutID = workoutID
        self.date = date
    }
    
    static func fake(_ weekday: Int) -> WorkoutSession {
        let workout = Workout.fake(weekday)
        let session = WorkoutSession(workoutID: workout.id, name: workout.name, date: Date())
        session.completions = workout.exercises
            .sorted { $0.position < $1.position }
            .map { ExerciseCompletion(
                exerciseID: $0.id,
                name: $0.name,
                position: $0.position
            ) }
        
        return session
    }
}

@Model
class ExerciseCompletion {
    var id: UUID
    var name: String
    var exerciseID: UUID
    var isComplete: Bool
    var position: Int
    
    init(
        exerciseID: UUID,
        name: String,
        position: Int
    ) {
        self.id = UUID()
        self.name = name
        self.exerciseID = exerciseID
        self.isComplete = false
        self.position = position
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


extension [Exercise] {
    func copy() -> Any {
        return self.map { Exercise(name: $0.name, position: $0.position) }
    }
    
    
    static func == (lhs: [Exercise], rhs: [Exercise]) -> Bool {
        if (lhs.count != rhs.count) {
            return false
        }
        
        let n = lhs.count
        
        for i in 0..<n {
            if lhs[i] != rhs[i] {
                return false;
            }
        }
        return true;
        
    }
}
