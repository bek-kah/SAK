import SwiftData
import SwiftUI

struct Weight {
    var value: Double
    var date: Date?
    var wasUserEntered: Bool
}

struct Activity: Equatable {
    var noData: Bool
    var move: Double
    var moveGoal: Double
    var exercise: Double
    var exerciseGoal: Double
    var stand: Double
    var standGoal: Double
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        let noDataSame = lhs.noData == rhs.noData
        let moveSame = lhs.move == rhs.move
        let moveGoalSame = lhs.moveGoal == rhs.moveGoal
        let exerciseSame = lhs.exercise == rhs.exercise
        let exerciseGoalSame = lhs.exerciseGoal == rhs.exerciseGoal
        let standSame = lhs.stand == rhs.stand
        let standGoalSame = lhs.standGoal == rhs.standGoal
        
        return noDataSame && moveSame && moveGoalSame && exerciseSame && exerciseGoalSame && standSame && standGoalSame
    }
}

// MARK: - DashboardView
struct DashboardView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var todaysWorkoutSession: WorkoutSession?
    @State var activity: Activity?
    @State var weight: Weight?
        
    @Query var allWorkouts: [Workout]
    @Query var sessions: [WorkoutSession]
    
    var todaysWorkout: Workout? {
        let workout = allWorkouts.first{ $0.day == weekdayString(forOffset: selectedDay) }
        print("Today's workout: \(String(describing: workout?.day ?? "N/A"))")
        return workout
    }
    
    @Binding private var selectedDay: Int

    let healthStore: HealthStore

    init(
        healthStore: HealthStore,
        selectedDay: Binding<Int>
    ) {
        self.healthStore = healthStore
        self._selectedDay = selectedDay
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                DaysScrollView(selectedDay: $selectedDay)
                dashboardGrid
                .padding(.horizontal)
            }
        }
        .onChange(of: selectedDay) {
            initialFetch()
        }
        .onChange(of: allWorkouts) {
            loadWorkoutSession()
        }
        .onAppear(perform: initialFetch)
        .animation(.default, value: selectedDay)
    }
}

// MARK: - DashboardView Subviews
private extension DashboardView {
    var dashboardGrid: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                Color.clear
                    .gridCellUnsizedAxes([.horizontal, .vertical])
            }

            GridRow {
                ForEach(0..<2) { i in
                    if i == 1, let weight = self.weight {
                        SquareTileView(
                            currentType: .weight(weight),
                            selectedDay: $selectedDay
                        )
                    } else if i == 0, let activity = self.activity {
                        SquareTileView(
                            currentType: .activity(activity),
                            selectedDay: $selectedDay
                        )
                    } else {
                        SquareTileView(selectedDay: $selectedDay)
                    }
                }
            }
            
            GridRow {
                if let todaysWorkout = todaysWorkout, let todaysWorkoutSession = todaysWorkoutSession {
                    SquareTileView(
                        currentType: .workout(todaysWorkout, todaysWorkoutSession, deleteSessions),
                        selectedDay: $selectedDay
                    )
                    .gridCellColumns(2)
                }
            }

            GridRow {
                ForEach(0..<2) { _ in
                    SquareTileView(selectedDay: $selectedDay)
                }
            }
        }
        .animation(.easeInOut, value: allWorkouts)
    }
    
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

// MARK: - DashboardView Data Fetching
private extension DashboardView {
    func weekdayString(forOffset offset: Int) -> String {
        let date = getSelectedDate(offset)

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }

    func initialFetch() {
        loadWorkoutSession()
        fetchWeight()
        fetchActivitySummary()
    }

    func fetchWeight() {
        healthStore.fetchWeight(selectedDay: getSelectedDate(selectedDay)) { weight, date, userEntered in
            self.weight = Weight(value: weight,
                                 date: date,
                                 wasUserEntered: userEntered)
        }
    }

    func fetchActivitySummary() {
        healthStore.fetchActivitySummary(selectedDay: getSelectedDate(selectedDay)) { noData, move, moveGoal, exercise, exerciseGoal, stand, standGoal in
            self.activity = Activity(noData: noData,
                                     move: move,
                                     moveGoal: moveGoal,
                                     exercise: exercise,
                                     exerciseGoal: exerciseGoal,
                                     stand: stand,
                                     standGoal: standGoal)
        }
    }
}

