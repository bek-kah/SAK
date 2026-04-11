import SwiftData
import SwiftUI

struct DashboardView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State var viewModel: ViewModel
    
    @Query var allWorkouts: [Workout]
    @Query var allSessions: [WorkoutSession]
    
    @Binding var selectedDay: Int
    @Binding var currentWeekIndex: Int?
    
    @Binding var refresh: Bool
    
    init(
        modelContext: ModelContext,
        healthStore: HealthStore,
        selectedDay: Binding<Int>,
        currentWeekIndex: Binding<Int?>,
        refresh: Binding<Bool>
    ) {
        _selectedDay = selectedDay
        _currentWeekIndex = currentWeekIndex
        _refresh = refresh
        _viewModel = State(initialValue:
                            ViewModel(
                                modelContext: modelContext,
                                healthStore: healthStore
                            )
        )
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                DaysScrollView(
                    selectedDay: $selectedDay,
                    currentWeekIndex: $currentWeekIndex
                )
                DashboardGrid(
                    modelContext: viewModel.modelContext,
                    weight: viewModel.weight,
                    activity: viewModel.activity,
                    todaysWorkout: viewModel.todaysWorkout,
                    todaysWorkoutSession: viewModel.todaysWorkoutSession,
                    selectedDay: selectedDay,
                    deleteSessions: viewModel.deleteSessions,
                    refresh: $refresh,
                )
                .padding(.horizontal)
            }
        }
        .onChange(of: selectedDay) {
            viewModel.initialFetch(
                selectedDay: selectedDay,
                workouts: allWorkouts,
                sessions: allSessions
            )
        }
        .onChange(of: allWorkouts) {
            viewModel.loadTodaysWorkout(
                selectedDay: selectedDay,
                allWorkouts: allWorkouts
            )
            viewModel.loadWorkoutSession(
                selectedDay: selectedDay,
                sessions: allSessions
            )
        }
        .onChange(of: refresh) {
            viewModel.initialFetch(
                selectedDay: selectedDay,
                workouts: allWorkouts,
                sessions: allSessions
            )
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                viewModel.initialFetch(
                    selectedDay: selectedDay,
                    workouts: allWorkouts,
                    sessions: allSessions
                )
            }
        }
        .onAppear {
            viewModel.initialFetch(
                selectedDay: selectedDay,
                workouts: allWorkouts,
                sessions: allSessions
            )
        }
        .onAppear {
            try? viewModel.backfillSessionNames()
        }
    }
}
