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
            
            ForEach(workoutSession.completions, id:\.id) { exerciseCompletion in
                HStack {
                    Button {
                        exerciseCompletion.isComplete.toggle()
                    } label: {
                        Image(systemName: exerciseCompletion.isComplete ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 5)
                    
                    Text(fetchExerciseName(exerciseCompletion.exerciseID))
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
    
    func fetchExerciseName(_ exerciseID: UUID) -> String {
        return workout.exercises.first(where: { $0.id == exerciseID })?.name ?? ""
    }
    
    func deleteWorkout() {
        
    }
}


#Preview {
    WorkoutTileView(workout: .fake("Sunday"), workoutSession: .fake("Sunday"), deleteSessions: {_ in } )
}
