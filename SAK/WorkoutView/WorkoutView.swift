import SwiftData
import SwiftUI
internal import Combine

struct WorkoutView: View {
    
    @State private var viewModel: ViewModel
    
    init(workoutSession: WorkoutSession) {
        _viewModel = State(initialValue: ViewModel(workoutSession: workoutSession))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.workoutSession.sortedCompletions, id:\.id) { completion in
                    ExerciseRow(completion: completion) {
                        viewModel.toggleCompletion(for: completion.exerciseID)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(viewModel.workoutSession.name)
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 20) {
                    Text(viewModel.formattedTime)
                        .font(.system(size: 24, weight: .thin, design: .monospaced))
                    
                    Spacer()
                    
                    Button {
                        viewModel.timerOn.toggle()
                    } label: {
                        Image(systemName: viewModel.timerOn ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
                .background(
                    Capsule()
                        .fill(.thickMaterial)
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    WorkoutView(workoutSession: .fake(0))
}
