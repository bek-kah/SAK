import Foundation
import SwiftUI

extension NewExercisesView {
    @Observable
    class ViewModel {
        
        var exercises: [Exercise]
        var name: String = ""
        
        init(exercises: [Exercise]) {
            self.exercises = exercises
        }
        
        func move(from source: IndexSet, to destination: Int) {
            exercises.move(fromOffsets: source, toOffset: destination)
            for (position, exercise) in exercises.enumerated() {
                exercise.position = position
            }
        }
        
        func delete(at offsets: IndexSet) {
            exercises.remove(atOffsets: offsets)
            for (position, exercise) in exercises.enumerated() {
                exercise.position = position
            }
        }
        
        func appendExercise() {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            exercises.append(Exercise(name: trimmed, position: exercises.count))
            name = ""
        }
    }
}
