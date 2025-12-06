import SwiftUI

struct WorkoutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workout.sortedExercises) { exercise in
                    HStack {
                        Text(exercise.name)
                            .font(.system(size: 16, weight: .regular))
                            .fontWidth(.expanded)
                        Spacer()
                        Button {
                            exercise.isComplete.toggle()
                        } label: {
                            Image(systemName: exercise.isComplete ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .foregroundStyle(.primary)
                    }
                    .padding(5)
                }
            }
            .navigationTitle(workout.name)
            
            .safeAreaInset(edge: .bottom) {
                if workout.exercises.allSatisfy({$0.isComplete}) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Complete")
                            Image(systemName: "checkmark")
                        }
                        .font(.system(size: 20, weight: .regular))
                        .fontWidth(.expanded)
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.background)
                    .tint(.primary)
                }
            }
        }
    }
}

#Preview {
    WorkoutView(workout: .fake)
}
