import Foundation
import SwiftData


@Model
class Workout {
    var name: String
    var day: String
    var exercises: [Exercise]
    var workoutHistory: [Date: [Exercise]] = [:]
    
    init(name: String, day: String, exercises: [Exercise]) {
        self.name = name
        self.day = day
        self.exercises = exercises
    }
    
    func saveWorkoutHistory(selectedDate: Date, exercises: [Exercise]) {
        workoutHistory[selectedDate] = exercises
    }
    
    func loadWorkoutHistory(selectedDate: Date) {
        if let exercises = workoutHistory[selectedDate] {
            self.exercises = exercises
            print("loading \(exercises.count) exercises for \(selectedDate.formatted())")
        } else {
            exercises = exercises.map { Exercise(name: $0.name, isComplete: false, orderIndex: $0.orderIndex) }
        }
    }
    
    static var fake: Workout {
        let exercises = [
            Exercise(name: "Chest Press", isComplete: false, orderIndex: 0),
            Exercise(name: "Shoulder Press", isComplete: true, orderIndex: 1),
            Exercise(name: "Fly", isComplete: false, orderIndex: 2)
        ]
        let workout = Workout(name: "Chest + Shoulders", day: "Monday", exercises: exercises)
        return workout
    }
}


class Exercise: Comparable, Codable, Equatable {
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
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
}
