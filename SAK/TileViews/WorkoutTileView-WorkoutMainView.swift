import SwiftData
import SwiftUI

extension WorkoutTileView {
    var exercisesWithCompletions: [(exercise: Exercise, completion: ExerciseCompletion)] {
        workout.sortedExercises.compactMap { exercise in
            guard let completion = workoutSession.completions.first(where: { $0.exerciseID == exercise.id }) else { return nil }
            return (exercise, completion)
        }
    }
    
    var workoutMainView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workoutSession.name.isEmpty ? workout.name : workoutSession.name)
                    .font(.system(size: 20, weight: .bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    showingWorkoutInfo = true
                } label: {
                    completeExercisesCountText
                }
                .buttonStyle(.bordered)
                .fontWidth(.expanded)
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .popover(isPresented: $showingWorkoutInfo) {
                    Text(workoutSession.id.uuidString)
                        .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.bottom)
            
            ForEach(exercisesWithCompletions, id: \.exercise.id) { exercise, completion in
                HStack {
                    Button {
                        toggleCompletion(for: exercise.id)
                    } label: {
                        Image(systemName: completion.isComplete ? "checkmark.circle.fill" : "circle")
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
                    showingEditWorkoutView = true
                } label: {
                    Text("Edit")
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .sheet(isPresented: $showingEditWorkoutView) {
                    EditWorkoutView(
                        workout: workout,
                        workoutSession: workoutSession,
                        deleteSessions: deleteSessions
                    )
                }
                
                Spacer()
                
                NavigationLink {
                    // WorkoutView(workout: workout, selectedDay: $selectedDay)
                }
                label: {
                    if !allExercisesComplete {
                        HStack {
                            Text("")
                            Image(systemName: "chevron.right")
                        }
                    } else {
                        HStack {
                            Text("Complete")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }
                .foregroundStyle(.secondary)
                .disabled(allExercisesComplete)
                
            }
            .padding(.top)
            .fontWidth(.expanded)
            .animation(.easeInOut, value: allExercisesComplete)
            .animation(.easeInOut, value: someExercisesComplete)
        }
        .padding()
    }
}

#Preview {
    WorkoutTileView(selectedDay: .constant(constantSelectedDay),workout: .fake(0), workoutSession: .fake(0), deleteSessions: { _ in } )
}
