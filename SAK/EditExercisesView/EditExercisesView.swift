import SwiftUI

struct EditExercisesView: View {
    
    @Binding var sortedExercises: [ExerciseDraft]
    
    @State private var viewModel: ViewModel
    
    init(sortedExercises: Binding<[ExerciseDraft]>) {
        _sortedExercises = sortedExercises
        
        let viewModel = ViewModel(sortedExercises: sortedExercises.wrappedValue)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add Exercise") {
                    HStack {
                        TextField("Name", text: $viewModel.name)
                        Spacer()
                        Button("add", action: viewModel.appendExercise)
                            .buttonStyle(.borderedProminent)
                            .font(.system(size: 14, weight: .regular))
                            .disabled(viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                
                if !sortedExercises.isEmpty {
                    Section {
                        ForEach(sortedExercises, id: \.id) { exercise in
                            HStack {
                                Text(exercise.name)
                            }
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
        .onChange(of: viewModel.sortedExercises) { _, newValue in
            sortedExercises = newValue
        }
    }
}

struct EditExercisesView_PreviewHost: View {
    @State private var sortedExercises: [ExerciseDraft] = []
    var body: some View {
        EditExercisesView(sortedExercises: $sortedExercises)
    }
}

#Preview {
    EditExercisesView_PreviewHost()
}

