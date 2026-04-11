import SwiftData
import SwiftUI

struct WorkoutTileView: View {
    
    @State private var viewModel: ViewModel
    @Binding private var refresh: Bool
    
    init(
        modelContext: ModelContext,
        workout: Workout,
        workoutSession: WorkoutSession,
        deleteSessions: @escaping (UUID, [WorkoutSession]) -> Void,
        refresh: Binding<Bool>
    ) {
        let viewModel = ViewModel(
            modelContext: modelContext,
            workout: workout,
            workoutSession: workoutSession,
            deleteSessions: deleteSessions
        )
        _viewModel = State(initialValue: viewModel)
        _refresh = refresh
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.workoutSession.name.isEmpty ? viewModel.workout.name : viewModel.workoutSession.name)
                    .font(.system(size: 20, weight: .bold))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    viewModel.showingWorkoutInfo = true
                } label: {
                    viewModel.completeExercisesCountText
                }
                .buttonStyle(.bordered)
                .fontWidth(.expanded)
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .popover(isPresented: $viewModel.showingWorkoutInfo) {
                    Text(viewModel.workoutSession.id.uuidString)
                        .presentationCompactAdaptation(.popover)
                }
            }
            .padding(.bottom)
            
            ForEach(viewModel.workoutSession.sortedCompletions, id: \.id) { completion in
                HStack {
                    Button {
                        viewModel.toggleCompletion(for: completion.exerciseID)
                    } label: {
                        Image(systemName: completion.isComplete ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 5)
                    
                    Text(completion.name)
                        .font(.system(size: 16, weight: .regular))
                        .fontWidth(.expanded)
                }
                .foregroundStyle(.secondary)
                .padding(.trailing, 5)
                .padding(.vertical, 5)
            }
            
            HStack {
                Button {
                    viewModel.showingEditWorkoutView = true
                } label: {
                    Text("Edit")
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .sheet(isPresented: $viewModel.showingEditWorkoutView) {
                    EditWorkoutView(
                        workout: viewModel.workout,
                        workoutSession: viewModel.workoutSession,
                        deleteSessions: viewModel.deleteSessions,
                        modelContext: viewModel.modelContext,
                        refresh: $refresh,
                    )
                }
                
                Spacer()
                
                NavigationLink {
                    WorkoutView(workoutSession: viewModel.workoutSession)
                }
                label: {
                    if !viewModel.allExercisesComplete {
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
                .disabled(viewModel.allExercisesComplete)
                
            }
            .padding(.top)
            .fontWidth(.expanded)
        }
        .padding()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, WorkoutSession.self, configurations: config)
    
    WorkoutTileView(
        modelContext: container.mainContext,
        workout: .fake(0),
        workoutSession: .fake(0),
        deleteSessions: { _, _ in },
        refresh: .constant(false)
    )
}
