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
    
    @Binding var selectedDay: Int

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
extension DashboardView {
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
}
