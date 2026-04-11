import Foundation
import HealthKit

extension NewWeightView {
    @Observable
    class ViewModel {
        var pounds: Double?
        var date: Date = .now
        var accessGranted = false
        var trigger = false
        
        let healthStore = HKHealthStore()
        let weightType: Set = [
            HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        func requestHealthAccess() {
            guard HKHealthStore.isHealthDataAvailable() else { return }
            trigger.toggle()
        }
        
        func handleAuthResult(_ result: Result<Bool, Error>) {
            switch result {
            case .success:
                accessGranted = true
            case .failure(let error):
                print("HealthKit auth error: \(error)")
            }
        }
        
        func addWeight(completion: @escaping () -> Void) {
            guard HKHealthStore.isHealthDataAvailable(), let pounds else { return }
            
            let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
            let quantity = HKQuantity(unit: .pound(), doubleValue: pounds)
            let sample = HKQuantitySample(type: weightType, quantity: quantity, start: date, end: date)
            
            healthStore.save(sample) { success, error in
                if success {
                    print("Successfully saved weight.")
                    completion()
                } else {
                    print("Error saving weight: \(String(describing: error))")
                }
            }
        }
        
        var canSave: Bool {
            pounds != nil && accessGranted
        }
    }
}
