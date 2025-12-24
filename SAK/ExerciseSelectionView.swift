import SwiftUI

struct ExerciseSelectionView: View {
    @State var title: String = ""
    @Binding var exercises: [Exercise]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section("New Exercise") {
                        HStack {
                            TextField("Push-ups", text: $title)
                            Spacer()
                            Button("Add") {
                                exercises.append(Exercise(name: title, orderIndex: exercises.count))
                                title = ""
                            }
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                            .disabled(title.isEmpty)
                        }
                    }
                    
                    Section("Exercises") {
                        if exercises.isEmpty {
                            Text("No exercises yet")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(exercises, id: \.id) { exercise in
                                Text(exercise.name)
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                        }
                    }
                }
            }
            .navigationTitle("Exercises")
            .toolbar {
                EditButton()
            }
        }
        .font(.system(size: 14, weight: .medium))
        .fontWidth(.expanded)
    }
    
    func delete(indexSet: IndexSet) {
        exercises.remove(atOffsets: indexSet)
        
        for i in exercises.indices {
            exercises[i].orderIndex = i
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
        
        for (index, exercise) in exercises.enumerated() {
            exercise.orderIndex = index
        }
    }
}
