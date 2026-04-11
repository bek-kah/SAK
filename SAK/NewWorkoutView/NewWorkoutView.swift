import SwiftData
import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: Bool
    
    @State private var viewModel: ViewModel
    
    private var refreshWorkouts: () -> Void
    
    init(
        modelContext: ModelContext,
        selectedDay: Int,
        refreshWorkouts: @escaping () -> Void
    ) {
        let viewModel = ViewModel(selectedDay: selectedDay, modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
        self.refreshWorkouts = refreshWorkouts
    }
    
    @State private var showPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $viewModel.name)
                    .focused($focusedField)
                
                NavigationLink {
                    NewExercisesView(exercises: $viewModel.exercises)
                } label: {
                    HStack {
                        Text("Exercises")
                        Spacer()
                        Text("\(viewModel.exercises.count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Button {
                    withAnimation {
                        showPicker.toggle()
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
                
                if showPicker {
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
            .navigationTitle("New Workout")
            .animation(.easeInOut, value: showPicker)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create", systemImage: "checkmark", role: .cancel) {
                        viewModel.createWorkout(completion: refreshWorkouts)
                        dismiss()
                    }
                    .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                focusedField = true
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, configurations: config)
    NewWorkoutView(
        modelContext: container.mainContext,
        selectedDay: 0,
        refreshWorkouts: {}
    )
    .modelContainer(container)
}
