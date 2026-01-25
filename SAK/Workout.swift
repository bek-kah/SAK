import Foundation
import SwiftData

@Model
class Workout {
    var id: UUID
    var name: String
    var day: String
    var exercises: [Exercise]
    
    init(name: String, day: String, exercises: [Exercise]) {
        self.id = UUID()
        self.name = name
        self.day = day
        self.exercises = exercises
    }
    
    static func fake(_ day: String) -> Workout {
        return Workout(
            name: "Chest Day",
            day: day,
            exercises: [
                Exercise(name: "Push-ups"),
                Exercise(name: "Bench Press"),
                Exercise(name: "Fly")
            ])
    }
}

@Model
class Exercise {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
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
    
    static func fake(_ day: String) -> WorkoutSession {
        let workout = Workout.fake(day)
        let session = WorkoutSession(workoutID: workout.id, date: Date())
        session.completions = workout.exercises.map { ExerciseCompletion(exerciseID: $0.id) }
        
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
