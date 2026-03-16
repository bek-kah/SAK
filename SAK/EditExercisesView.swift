import SwiftUI

struct EditExercisesView: View {
    
    @Binding var sortedExercises: [ExerciseDraft]
    @State private var name: String = ""
    @State private var showingExerciseInfo: [UUID: Bool] = [:]
    
    init(sortedExercises: Binding<[ExerciseDraft]>) {
        _sortedExercises = sortedExercises
        for sortedExercise in sortedExercises {
            showingExerciseInfo[sortedExercise.id] = false
        }
    }
    
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
                            HStack {
                                Text(exercise.name)
//                                Spacer()
//                                Button("", systemImage: "info.circle.fill") {
//                                    showingExerciseInfo[exercise.id] = true
//                                }
//                                .popover(isPresented: Binding(
//                                    get: { showingExerciseInfo[exercise.id] ?? false },
//                                    set: { showingExerciseInfo[exercise.id] = $0 }
//                                )) {
//                                    Text(exercise.id.uuidString)
//                                        .presentationCompactAdaptation(.popover)
//                                }
                            }
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
        for i in sortedExercises.indices {
            sortedExercises[i].position = i
        }
    }

    func delete(at offsets: IndexSet) {
        sortedExercises.remove(atOffsets: offsets)
        for i in sortedExercises.indices {
            sortedExercises[i].position = i
        }
    }

    func appendExercise() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        sortedExercises.append(ExerciseDraft(id: UUID(), name: trimmed, position: sortedExercises.count))
        name = ""
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

