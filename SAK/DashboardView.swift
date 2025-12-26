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
    @Query var workouts: [Workout]
    
    @State var showNewWorkout: Bool = false
    
    @State var activity: Activity?
    @State var weight: Weight?
    
    var todaysWorkout: Workout? {
        workouts.first { workout in
            workout.day == Calendar.current.weekdaySymbols[selectedDay % 7]
        }
    }

    @State private var selectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1

    let healthStore: HealthStore

    init(healthStore: HealthStore) {
        self.healthStore = healthStore
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
                            currentType: .weight(weight.value,
                                                 weight.date ?? Date(),
                                                 weight.wasUserEntered),
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
                if let workout = todaysWorkout {
                    SquareTileView(
                        currentType: .workout(workout),
                                   removeWorkout: removeWorkout,
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
        .sheet(isPresented: $showNewWorkout) {
            NewWorkoutView()
        }
    }
    
    func removeWorkout(_ workout: Workout) {
        modelContext.delete(workout)
        try? modelContext.save()
    }
}

// MARK: - DashboardView Data Fetching
private extension DashboardView {
    func initialFetch() {
        fetchWeight()
        fetchActivitySummary()
    }

    func fetchWeight() {
        healthStore.fetchWeight(selectedDate: getSelectedDate(selectedDay)) { weight, date, userEntered in
            self.weight = Weight(value: weight,
                                 date: date,
                                 wasUserEntered: userEntered)
        }
    }

    func fetchActivitySummary() {
        healthStore.fetchTodayActivitySummary(selectedDay: getSelectedDate(selectedDay)) { noData, move, moveGoal, exercise, exerciseGoal, stand, standGoal in
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

