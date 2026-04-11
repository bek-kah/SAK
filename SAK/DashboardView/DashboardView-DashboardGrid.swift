import SwiftData
import SwiftUI

extension DashboardView {
    struct DashboardGrid: View {
        var modelContext: ModelContext
        
        var weight: Weight?
        var activity: Activity?
        
        var todaysWorkout: Workout?
        var todaysWorkoutSession: WorkoutSession?
        
        var selectedDay: Int
        var deleteSessions: (UUID, [WorkoutSession]) -> ()
        
        @Binding var refresh: Bool
        
        init(
            modelContext: ModelContext,
            weight: Weight? = nil,
            activity: Activity? = nil,
            todaysWorkout: Workout? = nil,
            todaysWorkoutSession: WorkoutSession? = nil,
            selectedDay: Int,
            deleteSessions: @escaping (UUID, [WorkoutSession]) -> Void,
            refresh: Binding<Bool>
        ) {
            self.modelContext = modelContext
            self.weight = weight
            self.activity = activity
            self.todaysWorkout = todaysWorkout
            self.todaysWorkoutSession = todaysWorkoutSession
            self.selectedDay = selectedDay
            self.deleteSessions = deleteSessions
            _refresh = refresh
        }
        
        var body: some View {
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
                                selectedDay: selectedDay
                            )
                        } else if i == 0, let activity = self.activity {
                            SquareTileView(
                                currentType: .activity(activity),
                                selectedDay: selectedDay
                            )
                        } else {
                            SquareTileView(selectedDay: selectedDay)
                        }
                    }
                }
                
                GridRow {
                    if let todaysWorkout = todaysWorkout,
                       let todaysWorkoutSession = todaysWorkoutSession {
                        SquareTileView(
                            currentType: .workout(
                                modelContext,
                                todaysWorkout,
                                todaysWorkoutSession,
                                deleteSessions,
                                $refresh,
                            ),
                            selectedDay: selectedDay
                        )
                        .id(todaysWorkoutSession.id)
                        .gridCellColumns(2)
                    }
                }
                
                GridRow {
                    ForEach(0..<2) { _ in
                        SquareTileView(selectedDay: selectedDay)
                    }
                }
            }
        }
    }
}
