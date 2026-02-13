import SwiftData
import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var sessions: [WorkoutSession]
    
    var workout: Workout
    
    @State private var name: String
    @State private var weekday: Int
    @State private var exercises: [Exercise]
    
    @State private var showPicker: Bool = false
    
    init(workout: Workout) {
        self.workout = workout
        self.name = workout.name
        self.weekday = workout.weekday
        self.exercises = workout.exercises
    }
    
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
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark", role: .cancel) {
                        workout.name = name
                        workout.weekday = weekday
                        workout.exercises = exercises
                        updateSessions(workout: workout, workoutID: workout.id)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    func findSessions(
        workoutID: UUID
    ) -> [WorkoutSession]? {
        sessions.filter {
            $0.workoutID == workoutID
        }
    }
    
    func updateSessions(
        workout: Workout,
        workoutID: UUID
    ) {
        guard let sessions = findSessions(workoutID: workoutID) else { return }
        let updatedExerciseIDs = Set(workout.exercises.map { $0.id })
        
        for session in sessions {
            // Map existing completions by exerciseID
            let completionByID = Dictionary(uniqueKeysWithValues: session.completions.map { ($0.exerciseID, $0) })
            
            // Build new completions array in workout.exercises order
            session.completions = workout.exercises.map { exercise in
                if let existing = completionByID[exercise.id] {
                    return existing
                } else {
                    return ExerciseCompletion(exerciseID: exercise.id)
                }
            }
            // Any old completions for exercises no longer present are dropped.
        }
    }
}


#Preview {
    return EditWorkoutView(workout: .fake(0))
}
