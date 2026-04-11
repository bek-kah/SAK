import SwiftUI

struct NewExercisesView: View {
    
    @Binding private var exercises: [Exercise]
    
    @State private var viewModel: ViewModel
    
    init(exercises: Binding<[Exercise]>) {
        _exercises = exercises
        
        let viewModel = ViewModel(exercises: exercises.wrappedValue)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("New Exercise") {
                    HStack {
                        TextField("Name", text: $viewModel.name)
                        Spacer()
                        Button("add", action: viewModel.appendExercise)
                            .buttonStyle(.borderedProminent)
                            .font(.system(size: 14, weight: .regular))
                            .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                
                if !exercises.isEmpty {
                    Section {
                        ForEach(exercises, id: \.id) { exercise in
                            Text(exercise.name)
                        }
                        .onMove(perform: viewModel.move)
                        .onDelete(perform: viewModel.delete)
                    }
                }

            }
            .font(.system(size: 16, weight: .regular))
            .fontWidth(.expanded)
            .navigationTitle("Exercises")
            .toolbar {
                EditButton()
            }
        }
        .onChange(of: viewModel.exercises) { _, newValue in
            exercises = newValue
        }
    }
}

struct NewExercisesView_PreviewHost: View {
    @State private var exercises: [Exercise] = []
    var body: some View {
        NewExercisesView(exercises: $exercises)
    }
}

#Preview {
    NewExercisesView_PreviewHost()
}
