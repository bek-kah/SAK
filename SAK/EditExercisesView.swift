import SwiftUI

struct EditExercisesView: View {
    
    @Binding var sortedExercises: [Exercise]
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add Exercise") {
                    HStack {
                        TextField("Name", text: $name)
                        Spacer()
                        Button("add", action: appendExercise)
                            .buttonStyle(.borderedProminent)
                            .font(.system(size: 14, weight: .regular))
                            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                
                if !sortedExercises.isEmpty {
                    Section {
                        ForEach(sortedExercises, id: \.id) { exercise in
                            Text(exercise.name)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
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
    }
    
    func move(from source: IndexSet, to destination: Int) {
        sortedExercises.move(fromOffsets: source, toOffset: destination)
        for (position, exercise) in sortedExercises.enumerated() {
            exercise.position = position
        }
    }
    
    func delete(at offsets: IndexSet) {
        sortedExercises.remove(atOffsets: offsets)
        for (position, exercise) in sortedExercises.enumerated() {
            exercise.position = position
        }
    }
    
    func appendExercise() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        sortedExercises.append(Exercise(name: trimmed, position: sortedExercises.count))
        name = ""
    }
}

struct EditExercisesView_PreviewHost: View {
    @State private var sortedExercises: [Exercise] = []
    var body: some View {
        EditExercisesView(sortedExercises: $sortedExercises)
    }
}

#Preview {
    EditExercisesView_PreviewHost()
}

