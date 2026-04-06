import SwiftData
import SwiftUI

struct ExerciseRow: View {
    let completion: ExerciseCompletion
    var onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: completion.isComplete ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, 7)
            
            VStack(alignment: .leading) {
                Text(completion.name)
                    .font(.system(size: 16, weight: .regular))
                    .fontWidth(.expanded)
            }
            
            Spacer()
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(.regularMaterial)
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

#Preview {
    WorkoutView(workoutSession: .fake(0))
}
