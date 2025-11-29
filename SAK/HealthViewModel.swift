import SwiftUI
import HealthKit

@MainActor
final class HealthViewModel: ObservableObject {
    @Published var weight: Double = 0
    @Published var weightDate: Date?
    @Published var wasUserEntered: Bool = false
    
    @Published var noData: Bool = false
    @Published var move: Double = 0
    @Published var moveGoal: Double = 0
    @Published var exercise: Double = 0
    @Published var exerciseGoal: Double = 0
    @Published var stand: Double = 0
    @Published var standGoal: Double = 0
    
    private let healthStore = HealthStore()
    
    func requestHealthKitAccess() {
        healthStore.requestAuthorization { success, error in
            if let error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization successful.")
            }
        }
    }
    
    func fetchWeight() {
        healthStore.fetchLatestWeight { weightKg, date, userEntered in
            guard let weightKg else { return }
            Task { @MainActor in
                self.weight = weightKg * 2.20462 // Convert kg → lbs
                self.weightDate = date
                self.wasUserEntered = userEntered
            }
        }
    }
    
    func fetchActivitySummary() {
        healthStore.fetchTodayActivitySummary { noData, move, moveGoal, exercise, exerciseGoal, stand, standGoal in
            Task { @MainActor in
                self.noData = noData
                self.move = move
                self.moveGoal = moveGoal
                self.exercise = exercise
                self.exerciseGoal = exerciseGoal
                self.stand = stand
                self.standGoal = standGoal
            }
        }
    }
}
