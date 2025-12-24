import SwiftUI

struct WorkoutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    
    @Binding var selectedDay: Int
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workout.exercises.sorted(), id: \.id) { exercise in
                    HStack {
                        Button {
                            exercise.isComplete.toggle()
                        } label: {
                            Image(systemName: exercise.isComplete ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .padding(.trailing, 5)
                        
                        Text(exercise.name)
                            .font(.system(size: 16, weight: .regular))
                            .fontWidth(.expanded)
                    }
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)
                    .padding(.vertical, 5)
                }
                .listRowBackground(Color.clear)
            }

            .navigationTitle(workout.name)
            
            .safeAreaInset(edge: .bottom) {
                if workout.exercises.allSatisfy({$0.isComplete}) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Text("Complete")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        .padding(8)
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.primary)
                    .font(.system(size: 20, weight: .regular))
                    .fontWidth(.expanded)
                }
            }
        }
    }
}

#Preview {
    WorkoutView(workout: .fake, selectedDay: .constant(1))
}
