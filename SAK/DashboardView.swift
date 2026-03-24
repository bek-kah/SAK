import SwiftData
import SwiftUI

// MARK: - DashboardView
struct DashboardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    
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
    @Binding var currentWeekIndex: Int?

    let healthStore: HealthStore
    let refresh: Bool

    init(
        healthStore: HealthStore,
        selectedDay: Binding<Int>,
        currentWeekIndex: Binding <Int?>,
        refresh: Bool
    ) {
        self.healthStore = healthStore
        self._selectedDay = selectedDay
        self._currentWeekIndex = currentWeekIndex
        self.refresh = refresh
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                DaysScrollView(
                    selectedDay: $selectedDay,
                    currentWeekIndex: $currentWeekIndex
                )
                dashboardGrid
                .padding(.horizontal)
            }
        }
        .onChange(of: selectedDay) { initialFetch() }
        .onChange(of: allWorkouts) { loadWorkoutSession() }
        .onChange(of: refresh) { fetchWeight() }
        .onChange(of: scenePhase) {
            if scenePhase == .active { initialFetch() }
        }
        .onAppear(perform: initialFetch)
        .onAppear {
            try? backfillSessionNames(context: modelContext)
        }
        .animation(.default, value: selectedDay)
    }
}

func backfillSessionNames(context: ModelContext) throws {
    let sessions = try context.fetch(FetchDescriptor<WorkoutSession>())
    let workouts = try context.fetch(FetchDescriptor<Workout>())
    
    for session in sessions where session.name.isEmpty {
        if let workout = workouts.first(where: { $0.id == session.workoutID }) {
            session.name = workout.name
        }
    }
    try context.save()
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
    }
}
