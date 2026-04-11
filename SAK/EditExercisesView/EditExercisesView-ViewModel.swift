import Foundation
import SwiftUI

extension EditExercisesView {
    @Observable
    class ViewModel {
        var sortedExercises: [ExerciseDraft]
        var name: String = ""
        
        init(sortedExercises: [ExerciseDraft]) {
            self.sortedExercises = sortedExercises
        }
        
        func move(from source: IndexSet, to destination: Int) {
            sortedExercises.move(fromOffsets: source, toOffset: destination)
            for i in sortedExercises.indices {
                sortedExercises[i].position = i
            }
        }
        
        func delete(at offsets: IndexSet) {
            sortedExercises.remove(atOffsets: offsets)
            for i in sortedExercises.indices {
                sortedExercises[i].position = i
            }
        }
        
        func appendExercise() {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            sortedExercises.append(ExerciseDraft(id: UUID(), name: trimmed, position: sortedExercises.count))
            name = ""
        }
    }
}
