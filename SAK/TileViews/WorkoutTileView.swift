import SwiftData
import SwiftUI

struct WorkoutTileView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var workout: Workout
    @Bindable var workoutSession: WorkoutSession
    var deleteSessions: (UUID) -> Void
    
    @State private var showingDeleteAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.name)
                    .font(.system(size: 20, weight: .bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
            }
            .padding(.bottom)
            
            ForEach(workout.sortedExercises, id:\.id) { exercise in
                HStack {
                    Button {
                        toggleCompletion(for: exercise.id)
                    } label: {
                        let complete = isExerciseComplete(for: exercise.id)
                        Image(systemName: complete ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 5)

                    Text(exercise.name)
                        .font(.system(size: 16, weight: .regular))
                        .fontWidth(.expanded)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 5)
                .padding(.vertical, 5)
            }
            
            HStack {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
                .buttonStyle(.bordered)
                .confirmationDialog(
                    Text("Are you sure?"),
                    isPresented: $showingDeleteAlert,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        deleteSessions(workout.id)
                        modelContext.delete(workout)
                    }
                }
                
                Spacer()
                
                Button("Edit", action: {})
                    .foregroundStyle(.secondary)
                
                NavigationLink {
//                    WorkoutView(workout: workout, selectedDay: $selectedDay)
                }
                label: {
                    if workoutSession.completions.allSatisfy(\.isComplete) {
                        Text("Completed")
                        
                    } else {
                        Text("Start")
                    }
                }
                .disabled(workoutSession.completions.allSatisfy(\.isComplete) )
                .buttonStyle(.bordered)
                .foregroundStyle(.primary)
            }
            .padding(.top)
            .font(.system(size: 17, weight: .regular))
            .fontWidth(.expanded)
            .animation(.easeInOut, value: workoutSession.completions.allSatisfy(\.isComplete))
        }
        .padding()
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
    
    func deleteWorkout() {
        
    }
}


#Preview {
    WorkoutTileView(workout: .fake("Sunday"), workoutSession: .fake("Sunday"), deleteSessions: {_ in } )
}

