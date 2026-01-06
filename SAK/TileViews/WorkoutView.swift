import SwiftUI

struct WorkoutView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var workout: Workout
    
    @Binding var selectedDay: Int
    
    @State private var isRunning = false
    @State private var timer: Timer?
    
    private var formattedTime: String {
        let totalSeconds = Int(workout.duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(workout.exercises.sorted(), id: \.id) { exercise in
                        HStack {
                            Button {
                                exercise.isComplete.toggle()
                                workout.saveWorkoutHistory(selectedDate: getSelectedDate(selectedDay))
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
                        .padding(.vertical, 10)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .navigationTitle(workout.name)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                workout.saveWorkoutHistory(selectedDate: getSelectedDate(selectedDay))
            }
            
            .safeAreaInset(edge: .top) {
                ZStack {
                    Rectangle()
                        .fill(.tertiary)
                        .frame(width: .infinity, height: 40)
                        .clipShape(.rect(cornerRadius: 15))
                    HStack {
                        Button {
                            if isRunning {
                                stopTimer()
                            } else {
                                startTimer()
                            }
                        } label: {
                            Image(systemName: isRunning ? "pause" : "play.fill")
                                .font(.system(size: 16, weight: .regular))
                                .frame(width: 24, height: 24)
                                .tint(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(formattedTime)
                            .font(.system(size: 14, weight: .regular))
                            .fontWidth(.expanded)
                            .frame(minWidth: 80, alignment: .center)
                        
                        Spacer()
                        
                        Button {
                            resetTimer()
                        } label: {
                            Image(systemName: "square.fill")
                                .font(.system(size: 16, weight: .regular))
                                .frame(width: 24, height: 24)
                                .tint(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            
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
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            workout.duration += 0.01
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        stopTimer()
        workout.duration = 0
    }
}

#Preview {
    WorkoutView(workout: .fake, selectedDay: .constant(1))
}
