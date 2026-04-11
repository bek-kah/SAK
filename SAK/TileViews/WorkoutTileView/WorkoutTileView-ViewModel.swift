import Foundation
import SwiftData
import SwiftUI

extension WorkoutTileView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        
        var workout: Workout
        var workoutSession: WorkoutSession
        var deleteSessions: (UUID, [WorkoutSession]) -> ()
        
        var showingDeleteAlert: Bool = false
        var showingEditWorkoutView: Bool = false
        var showingWorkoutInfo: Bool = false
        
        var completeExercisesCountText: Text {
            let count = workout.exercises.filter { isExerciseComplete(for: $0.id) }.count
            return Text("\(count)/\(workout.exercises.count)")
        }
        
        var allExercisesComplete: Bool {
            return workoutSession.completions.allSatisfy(\.isComplete)
        }
        
        var someExercisesComplete: Bool {
            return workoutSession.completions.contains { $0.isComplete }
        }
        
        init(
            modelContext: ModelContext,
            workout: Workout,
            workoutSession: WorkoutSession,
            deleteSessions: @escaping (UUID, [WorkoutSession]) -> Void,
        ) {
            self.modelContext = modelContext
            self.workout = workout
            self.workoutSession = workoutSession
            self.deleteSessions = deleteSessions
        }
        
        func isExerciseComplete(for exerciseID: UUID) -> Bool {
            return workoutSession.completions.first(where: { $0.exerciseID == exerciseID })?.isComplete ?? false
        }
        
        func toggleCompletion(for exerciseID: UUID) {
            if let idx = workoutSession.completions.firstIndex(where: { $0.exerciseID == exerciseID }) {
                workoutSession.completions[idx].isComplete.toggle()
            }
        }
    }
}
