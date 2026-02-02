import SwiftData
import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var weekday: Int = 0
    @State private var exercises: [Exercise] = []
    
    @State private var showPicker: Bool = false
    
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = .current
        let symbols = formatter.weekdaySymbols
        if let symbols = symbols, symbols.isEmpty == false {
            return symbols
        } else {
            return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                
                NavigationLink {
                    NewExercisesView()
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
                            day: weekdays[weekday],
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
    NewWorkoutView()
}
