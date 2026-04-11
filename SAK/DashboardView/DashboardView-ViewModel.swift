import Foundation
import SwiftData
import SwiftUI

extension DashboardView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        
        var todaysWorkoutSession: WorkoutSession?
        var todaysWorkout: Workout?
        
        var activity: Activity?
        var weight: Weight?
        
        let healthStore: HealthStore
        
        init(
            modelContext: ModelContext,
            activity: Activity? = nil,
            weight: Weight? = nil,
            healthStore: HealthStore,
        ) {
            self.modelContext = modelContext
            self.activity = activity
            self.weight = weight
            self.healthStore = healthStore
        }
        
        func loadTodaysWorkout(
            selectedDay: Int,
            allWorkouts: [Workout]
        ) {
            self.todaysWorkout = allWorkouts.first(where: { workout in
                weekdays[workout.weekday] == weekdayString(forOffset: selectedDay)
            })
        }
        
        func loadWorkoutSession(
            selectedDay: Int,
            sessions: [WorkoutSession]
        ) {
            // If there are no workouts for today, then there are no sessions.
            guard let todaysWorkout else {
                todaysWorkoutSession = nil
                print("There is no workout for \(getSelectedDate(selectedDay).formatted())")
                return
            }
            let date = getSelectedDate(selectedDay)
            
            print(todaysWorkout.name)
            
            if let existing = findSession(
                sessions: sessions,
                workoutID: todaysWorkout.id,
                date: date
            ) {
                todaysWorkoutSession = existing
            } else {
                // Workout sessions aren't generated for dates in the past.
                if date < todaysWorkout.dateCreated {
                    todaysWorkoutSession = nil
                    return
                }
                let newSession = createSession(
                    workoutID: todaysWorkout.id,
                    name: todaysWorkout.name,
                    date: date
                )
                
                newSession.completions = todaysWorkout.exercises.map {
                    ExerciseCompletion(
                        exerciseID: $0.id,
                        name: $0.name,
                        position: $0.position
                    )
                }
                
                modelContext.insert(newSession)
                todaysWorkoutSession = newSession
            }
        }
        
        func findSession(
            sessions: [WorkoutSession],
            workoutID: UUID,
            date: Date
        ) -> WorkoutSession? {
            sessions.first {
                $0.workoutID == workoutID &&
                $0.date == date
            }
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
        
        func createSession(
            workoutID: UUID,
            name: String,
            date: Date
        ) -> WorkoutSession {
            let session = WorkoutSession(
                workoutID: workoutID,
                name: name,
                date: date
            )
            modelContext.insert(session)
            return session
        }
        
        func deleteSessions(
            workoutID: UUID,
            sessions: [WorkoutSession]
        ) {
            if let sessions = findSessions(
                sessions: sessions,
                workoutID: workoutID
            ) {
                for session in sessions {
                    modelContext.delete(session)
                }
            }
        }
        
        func weekdayString(forOffset offset: Int) -> String {
            let date = getSelectedDate(offset)
            
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateFormat = "EEEE"
            
            return formatter.string(from: date)
        }
        
        func initialFetch(
            selectedDay: Int,
            workouts: [Workout],
            sessions: [WorkoutSession]
        ) {
            loadTodaysWorkout(
                selectedDay: selectedDay,
                allWorkouts: workouts
            )
            loadWorkoutSession(
                selectedDay: selectedDay,
                sessions: sessions
            )
            fetchWeight(selectedDay: selectedDay)
            fetchActivitySummary(selectedDay: selectedDay)
        }
        
        func fetchWeight(
            selectedDay: Int
        ) {
            healthStore.fetchWeight(
                selectedDay: getSelectedDate(selectedDay)
            ) { weight, date, userEntered in
                self.weight = Weight(value: weight,
                                     date: date,
                                     wasUserEntered: userEntered)
            }
        }
        
        func fetchActivitySummary(
            selectedDay: Int
        ) {
            healthStore.fetchActivitySummary(
                selectedDay: getSelectedDate(selectedDay)
            ) { noData, move, moveGoal, exercise, exerciseGoal, stand, standGoal in
                self.activity = Activity(noData: noData,
                                         move: move,
                                         moveGoal: moveGoal,
                                         exercise: exercise,
                                         exerciseGoal: exerciseGoal,
                                         stand: stand,
                                         standGoal: standGoal)
            }
        }
        
        func backfillSessionNames() throws {
            let sessions = try modelContext.fetch(FetchDescriptor<WorkoutSession>())
            let workouts = try modelContext.fetch(FetchDescriptor<Workout>())
            
            for session in sessions where session.name.isEmpty {
                if let workout = workouts.first(where: { $0.id == session.workoutID }) {
                    session.name = workout.name
                }
            }
            try modelContext.save()
        }
    }
}
