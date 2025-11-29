import Foundation
import SwiftData


@Model
class Workout {
    var name: String
    var day: String
    var exercises: [Exercise]
    
    init(name: String, day: String, exercises: [Exercise]) {
        self.name = name
        self.day = day
        self.exercises = exercises
    }
    
    static var fake: Workout {
        let exercises = [
            Exercise(name: "Chest Press", isComplete: false),
            Exercise(name: "Shoulder Press", isComplete: true),
            Exercise(name: "Fly", isComplete: false)
        ]
        let workout = Workout(name: "Chest + Shoulders + Traps", day: "Mondaay", exercises: exercises)
        return workout
    }
}



@Model
class Exercise {
    var id: UUID
    var name: String
    var isComplete: Bool
    
    init(name: String, isComplete: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isComplete = isComplete
    }
}
