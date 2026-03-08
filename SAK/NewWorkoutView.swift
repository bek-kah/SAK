import SwiftData
import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var weekday: Int
    @State private var exercises: [Exercise] = []
    
    init(selectedDay: Int) {
        weekday = getWeekdayIndex(selectedDay)
    }
    
    @State private var showPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                
                NavigationLink {
                    NewExercisesView(exercises: $exercises)
                } label: {
                    HStack {
                        Text("Exercises")
                        Spacer()
                        Text("\(exercises.count)")
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
                        Text(weekdays[weekday])
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.secondary)
                    }
                    .tint(.primary)
                }
                
                if showPicker {
                    Picker("Day", selection: $weekday) {
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
                        let workout = Workout(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            weekday: weekday,
                            exercises: exercises
                        )
                        modelContext.insert(workout)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }

    }
}


#Preview {
    NewWorkoutView(selectedDay: 0)
}
