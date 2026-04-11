import SwiftData
import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    @Query var sessions: [WorkoutSession]
    
    @State private var viewModel: ViewModel
    
    @Binding private var refresh: Bool
    
    init(
        workout: Workout,
        workoutSession: WorkoutSession,
        deleteSessions: @escaping (UUID, [WorkoutSession]) -> Void,
        modelContext: ModelContext,
        refresh: Binding<Bool>
    ) {
        let viewModel = ViewModel(
            workout: workout,
            workoutSession: workoutSession,
            deleteSessions: deleteSessions,
            modelContext: modelContext
        )
        _viewModel = State(initialValue: viewModel)
        _refresh = refresh
    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $viewModel.name)
                
                NavigationLink {
                    EditExercisesView(sortedExercises: $viewModel.draftExercises)
                } label: {
                    HStack {
                        Text("Exercises")
                        Spacer()
                        Text("\(viewModel.draftExercises.count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                
                Button {
                    withAnimation {
                        viewModel.showPicker.toggle()
                    }
                } label: {
                    HStack {
                        Text("Day")
                        Spacer()
                        Text(weekdays[viewModel.weekday])
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.secondary)
                    }
                    .tint(.primary)
                }
                
                if viewModel.showPicker {
                    Picker("Day", selection: $viewModel.weekday) {
                        ForEach(0..<weekdays.count, id: \.self) {
                            Text(weekdays[$0])
                                .font(.system(size: 16, weight: .regular))
                                .fontWidth(.expanded)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .font(.system(size: 15, weight: .regular))
            .fontWidth(.expanded)
            .navigationTitle("Edit Workout")
            .animation(.easeInOut, value: viewModel.showPicker)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark", role: .confirm) {
                        viewModel.saveWorkout(sessions: sessions) {
                            refresh.toggle()
                        }
                        dismiss()
                    }
                    .disabled(viewModel.noChanges)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    viewModel.showingDeleteAlert = true
                } label: {
                    Text("Delete Workout")
                        .padding(.horizontal)
                        .padding(.vertical,3)
                }
                .confirmationDialog(
                    Text("Are you sure you want to delete this workout? All of its sessions will be deleted as well."),
                    isPresented: $viewModel.showingDeleteAlert,
                    titleVisibility: .visible
                ) {
                    Button("Delete Workout", role: .destructive) {
                        viewModel.deleteWorkout(sessions: sessions)
                        dismiss()
                    }
                }
                .foregroundStyle(.red)
                .buttonStyle(.bordered)
            }
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, WorkoutSession.self, configurations: config)
    
    EditWorkoutView(
        workout: .fake(0),
        workoutSession: .fake(0),
        deleteSessions: { _, _ in },
        modelContext: container.mainContext,
        refresh: .constant(false)
    )
}
