import Foundation
import SwiftData


@Model
class Workout {
    var name: String
    var day: String
    var exercises: [Exercise]
    var duration: TimeInterval
    
    var workoutHistory: [Date: WorkoutHistory] = [:]
    
    init(name: String, day: String, exercises: [Exercise], duration: TimeInterval) {
        self.name = name
        self.day = day
        self.exercises = exercises
        self.duration = duration
    }
    
    func saveWorkoutHistory(selectedDate: Date) {
        if workoutHistory.contains(where: { $0.key == selectedDate }) {
            workoutHistory[selectedDate]?.exercises = exercises
            workoutHistory[selectedDate]?.duration = duration
        } else {
            workoutHistory[selectedDate] = WorkoutHistory(exercises: exercises, duration: duration)
        }
        
        exercises = exercises
        duration = duration

        print("saved workout history for \(selectedDate.formatted())")
    }
    
    func loadWorkoutHistory(selectedDate: Date) {
        print(selectedDate.formatted())
        
        // exercises
        if let exercises = workoutHistory[selectedDate]?.exercises {
            self.exercises = exercises
            print("loading \(exercises.count) exercises for \(selectedDate.formatted())")
        } else {
            exercises = exercises.map { Exercise(name: $0.name, isComplete: false, orderIndex: $0.orderIndex) }
        }
        
        // duration
        if let duration = workoutHistory[selectedDate]?.duration {
            self.duration = duration
        } else {
            self.duration = 0.0
        }
    }
    
    static var fake: Workout {
        let exercises = [
            Exercise(name: "Chest Press", isComplete: false, orderIndex: 0),
            Exercise(name: "Shoulder Press", isComplete: true, orderIndex: 1),
            Exercise(name: "Fly", isComplete: false, orderIndex: 2)
        ]
        let workout = Workout(name: "Chest + Shoulders", day: "Monday", exercises: exercises, duration: 0.0)
        return workout
    }
}

class WorkoutHistory: Codable, Equatable {
    var id: UUID
    var exercises: [Exercise]
    var duration: TimeInterval
    
    init(id: UUID = UUID(), exercises: [Exercise] = [], duration: TimeInterval = 0) {
        self.id = id
        self.exercises = exercises
        self.duration = duration
    }
    
    static func == (lhs: WorkoutHistory, rhs: WorkoutHistory) -> Bool {
        return lhs.id == rhs.id
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
