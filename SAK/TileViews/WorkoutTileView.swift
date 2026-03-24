import SwiftData
import SwiftUI

struct WorkoutTileView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Binding var selectedDay: Int
    
    var workout: Workout
    @Bindable var workoutSession: WorkoutSession
    var deleteSessions: (UUID) -> Void
    
    @State var showingDeleteAlert: Bool = false
    @State var showingEditWorkoutView: Bool = false
    @State var showingWorkoutInfo: Bool = false
    
    @State var showingExerciseInfo: [UUID: Bool] = [:]
    
    @State var hideOverlay: Bool = false
    
    var completeExercisesCountText: Text {
        let count = workout.exercises.filter { isExerciseComplete(for: $0.id) }.count
        return Text("\(count)/\(workout.exercises.count)")
    }
    
    var allExercisesComplete: Bool {
        return workoutSession.completions.allSatisfy(\.isComplete)
    }
    
    var someExercisesComplete: Bool {
        return workoutSession.completions.contains { $0.isComplete }
    }
    
    init(
        selectedDay: Binding<Int>,
        workout: Workout,
        workoutSession: WorkoutSession,
        deleteSessions: @escaping (UUID) -> Void
    ) {
        self._selectedDay = selectedDay
        self.workout = workout
        self.workoutSession = workoutSession
        self.deleteSessions = deleteSessions
        for exercise in workout.exercises {
            showingExerciseInfo[exercise.id] = false
        }
    }
    
    var body: some View {
        workoutMainView
    }
    
    func isExerciseComplete(for exerciseID: UUID) -> Bool {
        // Find the completion that corresponds to this exercise ID
        return workoutSession.completions.first(where: { $0.exerciseID == exerciseID })?.isComplete ?? false
    }
    
    func toggleCompletion(for exerciseID: UUID) {
        // Find the index of the completion so we can mutate it in-place
        if let idx = workoutSession.completions.firstIndex(where: { $0.exerciseID == exerciseID }) {
            workoutSession.completions[idx].isComplete.toggle()
        }
    }
}


#Preview {
    WorkoutTileView(selectedDay: .constant(constantSelectedDay), workout: .fake(0), workoutSession: .fake(0), deleteSessions: { _ in } )
}
