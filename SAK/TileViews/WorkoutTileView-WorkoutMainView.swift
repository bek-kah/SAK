import SwiftData
import SwiftUI

extension WorkoutTileView {
    var workoutMainView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.name)
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
                    //
                    //                    Spacer()
                    //
                    //                    Button("", systemImage: "info.circle.fill") {
                    //                        showingExerciseInfo[exercise.id] = true
                    //                    }
                    //                    .popover(isPresented: Binding(
                    //                        get: { showingExerciseInfo[exercise.id] ?? false },
                    //                        set: { showingExerciseInfo[exercise.id] = $0 }
                    //                    )) {
                    //                        Text(exercise.id.uuidString)
                    //                            .presentationCompactAdaptation(.popover)
                    //                    }
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 5)
                .padding(.vertical, 5)
            }
            
            HStack {
//                Button {
//                    showingDeleteAlert = true
//                } label: {
//                    Text("Delete")
//                }
//                .tint(.red)
//                .buttonStyle(.bordered)
//                .confirmationDialog(
//                    Text("Are you sure?"),
//                    isPresented: $showingDeleteAlert,
//                    titleVisibility: .visible
//                ) {
//                    Button("Delete", role: .destructive) {
//                        deleteSessions(workout.id)
//                        modelContext.delete(workout)
//                    }
//                }
                
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
                        deleteSessions: deleteSessions
                    )
                }
                
                Spacer()
                
                NavigationLink {
                    //                    WorkoutView(workout: workout, selectedDay: $selectedDay)
                }
                label: {
                    if !allExercisesComplete {
                        HStack {
//                            Text(someExercisesComplete ? "Continue" : "Start")
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
//                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .disabled(allExercisesComplete)
                
            }
            .padding(.top)
//            .font(.system(size: 17, weight: .regular)
            .fontWidth(.expanded)
            .animation(.easeInOut, value: allExercisesComplete)
            .animation(.easeInOut, value: someExercisesComplete)
        }
        .padding()
    }
}

#Preview {
    WorkoutTileView(workout: .fake(0), workoutSession: .fake(0), deleteSessions: {_ in } )
}
