import Foundation
import SwiftData

struct ExerciseDraft: Identifiable, Equatable {
    var id: UUID
    var name: String
    var position: Int
}

extension EditWorkoutView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        
        var workout: Workout
        var workoutSession: WorkoutSession
        
        var deleteSessions: (UUID, [WorkoutSession]) -> Void
        
        var name: String
        var weekday: Int
        var draftExercises: [ExerciseDraft]
        
        var showPicker: Bool = false
        var showingDeleteAlert: Bool = false
        
        var noChanges: Bool {
            workout.name == name &&
            workout.weekday == weekday &&
            workout.sortedExercises.map { ExerciseDraft(id: $0.id, name: $0.name, position: $0.position) } == draftExercises
        }
        
        init(
            workout: Workout,
            workoutSession: WorkoutSession,
            deleteSessions: @escaping (UUID, [WorkoutSession]) -> Void,
            modelContext: ModelContext
        ) {
            self.workout = workout
            self.workoutSession = workoutSession
            self.name = workout.name
            self.weekday = workout.weekday
            self.draftExercises = workout.sortedExercises.map {
                ExerciseDraft(id: $0.id, name: $0.name, position: $0.position)
            }
            self.deleteSessions = deleteSessions
            self.modelContext = modelContext
        }
        
        func deleteWorkout(
            sessions: [WorkoutSession]
        ) {
            deleteSessions(workout.id, sessions)
            modelContext.delete(workout)
        }
        
        func saveWorkout(
            sessions: [WorkoutSession],
            completion: @escaping () -> Void
        ) {
            workout.name = name
            workout.weekday = weekday
            
            let existingExercisesByID = Dictionary(uniqueKeysWithValues: workout.exercises.map { ($0.id, $0) } )
            
            /// Since Exercise is a class, editing them makes immediate changes.
            /// Therefore, we create an ExerciseDraft with the same information and pass in its variables back to the Exercise when the user decides to save their modification.
            workout.exercises = draftExercises.map { draftExercise in
                if let existing = existingExercisesByID[draftExercise.id] {
                    existing.name = draftExercise.name
                    existing.position = draftExercise.position
                    return existing
                } else {
                    let newExercise = Exercise(name: draftExercise.name, position: draftExercise.position)
                    modelContext.insert(newExercise)
                    return newExercise
                }
            }
            
            let draftIDs = Set(draftExercises.map( { $0.id } ))
            for exercise in existingExercisesByID.values where !draftIDs.contains(exercise.id) {
                modelContext.delete(exercise)
            }
            
            updateSessions(
                sessions: sessions,
                workout: workout,
                workoutID: workout.id
            )
            
            try? modelContext.save()
            completion()
        }
        
        func findSessions(
            sessions: [WorkoutSession],
            workoutID: UUID,
            after editDate: Date? = nil
        ) -> [WorkoutSession]? {
            if let editDate = editDate {
                return sessions.filter {
                    $0.workoutID == workoutID &&
                    $0.date >= editDate
                }
            } else {
                return sessions.filter {
                    $0.workoutID == workoutID
                }
            }
        }
        
        /// Updates the sessions, belonging to the selected date
        /// and onwards, with the same workoutID as the updated workout.
        func updateSessions(
            sessions: [WorkoutSession],
            workout: Workout,
            workoutID: UUID
        ) {
            guard let sessions = findSessions(
                sessions: sessions,
                workoutID: workoutID,
                after: workoutSession.date
            ) else { return }
            
            for session in sessions {
                session.name = name
                
                let sessionWeekday = Calendar.current.component(.weekday, from: session.date) - 1
                let weekdayDifference = workout.weekday - sessionWeekday
                session.date = Calendar.current.date(byAdding: .day, value: weekdayDifference, to: session.date) ?? session.date
                
                let completionByID = Dictionary(uniqueKeysWithValues: session.completions.map { ($0.exerciseID, $0) })
                session.completions = workout.exercises.map { exercise in
                    if let existing = completionByID[exercise.id] {
                        existing.position = exercise.position
                        return existing
                    } else {
                        return ExerciseCompletion(
                            exerciseID: exercise.id,
                            name: exercise.name,
                            position: exercise.position
                        )
                    }
                }
            }
        }
    }
}
