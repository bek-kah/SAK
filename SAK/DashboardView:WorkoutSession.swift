import SwiftData
import SwiftUI

extension DashboardView {
    func loadWorkoutSession() {
        // If there are no workouts for today, then there are no sessions.
        guard let todaysWorkout else {
            todaysWorkoutSession = nil
            return
        }
        let date = getSelectedDate(selectedDay)
        
        if let existing = findSession(
            workoutID: todaysWorkout.id,
            date: date
        ) {
            todaysWorkoutSession = existing
        } else {
            let newSession = createSession(
                workoutID: todaysWorkout.id,
                date: date
            )
            
            newSession.completions = todaysWorkout.exercises.map {
                ExerciseCompletion(exerciseID: $0.id)
            }
            
            modelContext.insert(newSession)
            todaysWorkoutSession = newSession
        }
    }
    
    func findSession(
        workoutID: UUID,
        date: Date
    ) -> WorkoutSession? {
        sessions.first {
            $0.workoutID == workoutID &&
            $0.date == date
        }
    }
    
    func findSessions(
        workoutID: UUID
    ) -> [WorkoutSession]? {
        sessions.filter {
            $0.workoutID == workoutID
        }
    }
    
    func createSession(
        workoutID: UUID,
        date: Date
    ) -> WorkoutSession {
        let session = WorkoutSession(
            workoutID: workoutID,
            date: date
        )
        modelContext.insert(session)
        return session
    }
    
    func deleteSessions(
        workoutID: UUID
    ) {
        if let sessions = findSessions(workoutID: workoutID) {
            for session in sessions {
                modelContext.delete(session)
            }
        }
    }
}
