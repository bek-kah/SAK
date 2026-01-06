import SwiftData
import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var title = ""
    @State private var selectedDay = "Monday"
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    @State private var exercises: [Exercise] = []
    @State private var daysHidden = true
    
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
            .navigationTitle("New Workout")
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
    
    func save() {
        let newWorkout = Workout(name: title, day: selectedDay, exercises: exercises, duration: 0)
        modelContext.insert(newWorkout)
    }
}

#Preview {
    NewWorkoutView()
}


struct PickerWheel: View {
    var values: [String]
    @Binding var selection: String
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(values, id: \.self) { value in
                Text(value)
            }
        }
        .pickerStyle(.wheel)
    }
}


struct DropdownSection: View {
    @Binding var toggle: Bool
    @Binding var text: String
    
    var body: some View {
        Button {
            withAnimation {
                toggle.toggle()
            }
        } label: {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(toggle ? 0 : -180))
                    .animation(.easeInOut, value: toggle)
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(.plain)
    }
}

