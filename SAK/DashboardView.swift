import SwiftData
import SwiftUI

// MARK: - DashboardView
struct DashboardView: View {
    @Environment(\.modelContext) var modelContext
    
    @State var todaysWorkoutSession: WorkoutSession?
    @State var activity: Activity?
    @State var weight: Weight?
        
    @Query var allWorkouts: [Workout]
    @Query var sessions: [WorkoutSession]
    
    var todaysWorkout: Workout? {
        allWorkouts.first(where: { workout in
            weekdays[workout.weekday] == weekdayString(forOffset: selectedDay)
        })
    }
    
    @Binding var selectedDay: Int

    let healthStore: HealthStore
    let refresh: Bool

    init(
        healthStore: HealthStore,
        selectedDay: Binding<Int>,
        refresh: Bool
    ) {
        self.healthStore = healthStore
        self._selectedDay = selectedDay
        self.refresh = refresh
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
        .onChange(of: refresh) {
            fetchWeight()
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
        .animation(.easeInOut, value: todaysWorkoutSession)
    }
}

