import SwiftData
import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    let workout: Workout
    
    @State private var title: String
    @State private var selectedDay: String
    @State private var exercises: [Exercise]
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @State private var daysHidden = true
    
    init(workout: Workout, title: String = "", selectedDay: String = "Monday", exercises: [Exercise] = []) {
        self.workout = workout
        self.title = workout.name
        self.selectedDay = workout.day
        self.exercises = workout.sortedExercises
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Push Day", text: $title)
                }
                Section("Day") {
                    DropdownSection(toggle: $daysHidden, text: $selectedDay)
                    if !daysHidden {
                        PickerWheel(values: daysOfWeek, selection: $selectedDay)
                    }
                }
                Section("Exercises") {
                    NavigationLink(destination: ExerciseSelectionView(exercises: $exercises)) {
                        Text("\(exercises.count)")
                    }
                }

            }
            .navigationTitle("Edit Workout")
            .font(.system(size: 14, weight: .medium))
            .fontWidth(.expanded)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("", systemImage: "xmark") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("", systemImage: "checkmark") {
                        save()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func save() {
        workout.name = title
        workout.day = selectedDay
        workout.exercises = exercises

        do {
            try modelContext.save()
        } catch {
            print("Failed to save workout: \(error)")
        }
    }
}

#Preview {
    NewWorkoutView()
}
