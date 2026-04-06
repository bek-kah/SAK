import Foundation
internal import Combine

extension WorkoutView {
    @Observable
    class ViewModel {
        var workoutSession: WorkoutSession
        var timerOn: Bool = false
        var elapsedSeconds: Int = 0
        
        private var cancellables = Set<AnyCancellable>()
        private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        init(workoutSession: WorkoutSession) {
            self.workoutSession = workoutSession
            timer
                .sink { [weak self] _ in
                    guard let self, self.timerOn else { return }
                    self.elapsedSeconds += 1
                }
                .store(in: &cancellables)
        }
        
        var formattedTime: String {
            let hours = elapsedSeconds / 3600
            let minutes = (elapsedSeconds % 3600) / 60
            let seconds = elapsedSeconds % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        
        func isExerciseComplete(for exerciseID: UUID) -> Bool {
            // Find the completion that corresponds to this exercise ID
            return workoutSession.completions.first(where: { $0.exerciseID == exerciseID })?.isComplete ?? false
        }
        
        func toggleCompletion(for exerciseID: UUID) {
            // Find the index of the completion so we can mutate it in-place
            if let idx = workoutSession.completions.firstIndex(where: { $0.exerciseID == exerciseID }) {
                workoutSession.completions[idx].isComplete.toggle()
            }
        }
    }
}
