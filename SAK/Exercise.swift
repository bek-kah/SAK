import Foundation
import SwiftData


@Model
class Workout {
    var name: String
    var day: String
    var exercises: [Exercise]
    var sortedExercises: [Exercise] {
        exercises.sorted()
    }
    
    init(name: String, day: String, exercises: [Exercise]) {
        self.name = name
        self.day = day
        self.exercises = exercises
    }
    
    static var fake: Workout {
        let exercises = [
            Exercise(name: "Chest Press", isComplete: false, orderIndex: 0),
            Exercise(name: "Shoulder Press", isComplete: true, orderIndex: 1),
            Exercise(name: "Fly", isComplete: false, orderIndex: 2)
        ]
        let workout = Workout(name: "Chest + Shoulders + Traps", day: "Mondaay", exercises: exercises)
        return workout
    }
}



@Model
class Exercise: Comparable {
    var id: UUID
    var name: String
    var isComplete: Bool
    var orderIndex: Int
    
    init(name: String, isComplete: Bool = false, orderIndex: Int) {
        self.id = UUID()
        self.name = name
        self.isComplete = isComplete
        self.orderIndex = orderIndex
    }
    
    static func < (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.orderIndex < rhs.orderIndex
    }
}
