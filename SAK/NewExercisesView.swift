import SwiftUI

struct NewExercisesView: View {
    
    @Binding var exercises: [Exercise]
    
    @State private var name: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("New Exercise") {
                    HStack {
                        TextField("Name", text: $name)
                        Spacer()
                        Button("add", action: appendExercise)
                            .buttonStyle(.borderedProminent)
                            .font(.system(size: 14, weight: .regular))
                            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                
                if !exercises.isEmpty {
                    Section {
                        ForEach(exercises, id: \.id) { exercise in
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
        exercises.move(fromOffsets: source, toOffset: destination)
        for (position, exercise) in exercises.enumerated() {
            exercise.position = position
        }
    }
    
    func delete(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
        for (position, exercise) in exercises.enumerated() {
            exercise.position = position
        }
    }
    
    func appendExercise() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        exercises.append(Exercise(name: trimmed, position: exercises.count))
        name = ""
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

