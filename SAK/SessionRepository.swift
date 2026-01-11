import Foundation
import SwiftData

struct SessionRepository {
    let context: ModelContext

    func weekStart(for date: Date) -> Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: date)?.start ?? date
    }

    func findSession(workoutID: UUID, weekStart: Date) -> WorkoutSession? {
        let descriptor = FetchDescriptor<WorkoutSession>(
            predicate: #Predicate { $0.workoutID == workoutID && $0.weekStart == weekStart },
            sortBy: []
        )
        return (try? context.fetch(descriptor))?.first
    }

    func createSession(workoutID: UUID, exerciseTemplateIDs: [UUID], weekStart: Date) -> WorkoutSession {
        let completions = exerciseTemplateIDs.map { ExerciseCompletion(templateID: $0) }
        let session = WorkoutSession(workoutID: workoutID, weekStart: weekStart, completions: completions)
        context.insert(session)
        try? context.save()
        return session
    }

    func findOrCreateSession(for workout: Workout, date: Date) -> WorkoutSession {
        let start = weekStart(for: date)
        if let existing = findSession(workoutID: workout.id, weekStart: start) {
            return existing
        }
        let exerciseIDs = workout.exercises.map { $0.id }
        return createSession(workoutID: workout.id, exerciseTemplateIDs: exerciseIDs, weekStart: start)
    }
}
