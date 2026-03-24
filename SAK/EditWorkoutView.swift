import SwiftData
import SwiftUI

struct ExerciseDraft: Identifiable, Equatable {
    var id: UUID
    var name: String
    var position: Int
}

struct EditWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var sessions: [WorkoutSession]
    var workout: Workout
    var workoutSession: WorkoutSession
    
    var deleteSessions: (UUID) -> Void
    
    @State private var name: String
    @State private var weekday: Int
    @State private var draftExercises: [ExerciseDraft]
    
    @State private var showPicker: Bool = false
    @State private var showingDeleteAlert: Bool = false
    
    private var noChanges: Bool {
        workout.name == name &&
        workout.weekday == weekday &&
        workout.sortedExercises.map { ExerciseDraft(id: $0.id, name: $0.name, position: $0.position) } == draftExercises
    }
    
    init(
        workout: Workout,
        workoutSession: WorkoutSession,
        deleteSessions: @escaping (UUID) -> Void
    ) {
        self.workout = workout
        self.workoutSession = workoutSession
        self.name = workout.name
        self.weekday = workout.weekday
        self.draftExercises = workout.sortedExercises.map {
            ExerciseDraft(id: $0.id, name: $0.name, position: $0.position)
        }
        self.deleteSessions = deleteSessions
    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Name", text: $name)
                
                NavigationLink {
                    EditExercisesView(sortedExercises: $draftExercises)
                } label: {
                    HStack {
                        Text("Exercises")
                        Spacer()
                        Text("\(draftExercises.count)")
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
            .navigationTitle("Edit Workout")
            .animation(.easeInOut, value: showPicker)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark", role: .confirm) {
                        saveWorkout()
                        dismiss()
                    }
                    .disabled(noChanges)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Text("Delete Workout")
                        .padding(.horizontal)
                        .padding(.vertical,3)
                }
                .confirmationDialog(
                    Text("Are you sure you want to delete this workout? All of its sessions will be deleted as well."),
                    isPresented: $showingDeleteAlert,
                    titleVisibility: .visible
                ) {
                    Button("Delete Workout", role: .destructive) {
                        deleteSessions(workout.id)
                        modelContext.delete(workout)
                        dismiss()
                    }
                }
//                .fontWidth(.standard)
                .foregroundStyle(.red)
                .buttonStyle(.bordered)
            }
        }
    }
    
    func saveWorkout() {
        workout.name = name
        workout.weekday = weekday
        
        let existingExercisesByID = Dictionary(uniqueKeysWithValues: workout.exercises.map { ($0.id, $0) } )
        
        /// Since Exercise is a class, editing them makes immediate changes.
        /// Therefore, we create a ExerciseDraft with the same information and pass in its variables back to the Exercise when user decides to save modification.
        workout.exercises = draftExercises.map { draftExercise in
            if let existing = existingExercisesByID[draftExercise.id] {
                existing.name = draftExercise.name
                existing.position = draftExercise.position
                return existing
            } else {
                let newExercise = Exercise(name: draftExercise.name, position: draftExercise.position)
                modelContext.insert(newExercise)
                return newExercise
            }
        }
        
        let draftIDs = Set(draftExercises.map( { $0.id } ))
        for exercise in existingExercisesByID.values where !draftIDs.contains(exercise.id) {
            modelContext.delete(exercise)
        }
        
        updateSessions(workout: workout, workoutID: workout.id)
    }
    
    func findSessions(
        workoutID: UUID,
        after editDate: Date? = nil
    ) -> [WorkoutSession]? {
        if let editDate = editDate {
            return sessions.filter {
                $0.workoutID == workoutID &&
                $0.date >= editDate
            }
        } else {
            return sessions.filter {
                $0.workoutID == workoutID
            }
        }
    }
    
    /// Update every current and future WorkoutSession
    func updateSessions(
        workout: Workout,
        workoutID: UUID
    ) {
        guard let sessions = findSessions(workoutID: workoutID, after: workoutSession.date) else { return }
        
        for session in sessions {
            
            // Adjust the weekday of each session to match the updated workout
            session.name = name
            let sessionWeekday = Calendar.current.component(.weekday, from: session.date) - 1
            let weekdayDifference = workout.weekday - sessionWeekday
            session.date = Calendar.current.date(byAdding: .day, value: weekdayDifference, to: session.date) ?? session.date
            
            // Map existing completions by exerciseID
            let completionByID = Dictionary(uniqueKeysWithValues: session.completions.map { ($0.exerciseID, $0) })
            
            // Build new completions array in workout.exercises order
            session.completions = workout.exercises.map { exercise in
                if let existing = completionByID[exercise.id] {
                    return existing
                } else {
                    return ExerciseCompletion(
                        exerciseID: exercise.id,
                        name: exercise.name,
                        position: exercise.position
                    )
                }
            }
        }
    }
}


#Preview {
    EditWorkoutView(workout: .fake(0), workoutSession: .fake(0), deleteSessions: { _ in })
}

#Preview {
    WorkoutTileView(selectedDay: .constant(constantSelectedDay), workout: .fake(0), workoutSession: .fake(0), deleteSessions: { _ in } )
}
