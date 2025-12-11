import SwiftUI

struct WorkoutTileView: View {
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    
    let removeWorkout: (Workout) -> Void?
    
    @State private var showEditWorkout: Bool = false
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
            
            ForEach(workout.sortedExercises, id: \.id) { exercise in
                HStack {
                    Button {
                        exercise.isComplete.toggle()
                    } label: {
                        Image(systemName: exercise.isComplete ? "checkmark.circle.fill" : "circle")
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
                        withAnimation {
                            removeWorkout(workout)
                        }
                    }
                }
                
                Spacer()
                
                Button("Edit", action: editWorkout)
                    .foregroundStyle(.secondary)
                
                NavigationLink {
                    WorkoutView(workout: workout)
                }
                label: {
                    if workout.exercises.allSatisfy(\.isComplete) {
                        Text("Completed")
                        
                    } else {
                        Text("Start")
                    }
                }
                .disabled(workout.exercises.allSatisfy(\.isComplete) )
                .buttonStyle(.bordered)
                .foregroundStyle(.primary)
            }
            .padding(.top)
            .font(.system(size: 17, weight: .regular))
            .fontWidth(.expanded)
            .animation(.easeInOut, value: workout.exercises.map(\.isComplete))
        }
        .padding()
        .sheet(isPresented: $showEditWorkout) {
            EditWorkoutView(workout: workout)
        }
    }
    
    func editWorkout() {
        showEditWorkout = true
    }
}

#Preview {
    WorkoutTileView(workout: .fake, removeWorkout: { _ in })
}
