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
                                exercises.append(Exercise(name: title))
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
                            ForEach(exercises, id: \.self) { exercise in
                                Text(exercise.name)
                            }
                            .onDelete { indexSet in
                                exercises.remove(atOffsets: indexSet)
                            }
                            .onMove { indices, newOffset in
                                exercises.move(fromOffsets: indices, toOffset: newOffset)
                            }
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
}

