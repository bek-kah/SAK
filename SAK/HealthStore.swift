import Foundation
import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let activitySummaryType = HKObjectType.activitySummaryType()
        
        let typesToRead: Set = [stepCountType, heartRateType, calorieType, weightType, activitySummaryType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    
    func fetchWeight(
        selectedDay: Date = Date(),
        completion: @escaping (
            _ pounds: Double,
            _ date: Date?,
            _ wasUserEntered: Bool
        ) -> Void) {
            let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
            
            let calendar = Calendar.current
            var comps = calendar.dateComponents([.year, .month, .day], from: selectedDay)
            comps.calendar = calendar
            let start = Calendar.current.startOfDay(for: selectedDay)
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
            
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [.strictStartDate])
            
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: weightType,
                                      predicate: predicate,
                                      limit: 1,
                                      sortDescriptors: [sort]) { _, samples, error in
                guard error == nil, let sample = samples?.first as? HKQuantitySample else {
                    DispatchQueue.main.async { completion(0, nil, false) }
                    return
                }
                
                let pounds = sample.quantity.doubleValue(for: .pound())
                let date = sample.endDate
                let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false
                
                DispatchQueue.main.async {
                    completion(pounds, date, wasUserEntered)
                }
            }
            
            healthStore.execute(query)
        }
    

    func fetchActivitySummary(
        selectedDay: Date = Date(),
        completion: @escaping (
            _ noData: Bool,
            _ move: Double, _ moveGoal: Double,
            _ exercise: Double, _ exerciseGoal: Double,
            _ stand: Double, _ standGoal: Double
        ) -> Void
    ) {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day], from: selectedDay)
        comps.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: comps)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, error in
            if let error = error {
                print("HKActivitySumamryQuery error:", error)
            }
            
            guard error == nil, let summary = summaries?.first else {
                DispatchQueue.main.async {
                    completion(true, 0, 0, 0, 0, 0, 0)
                }
                return
            }
            
            let move = summary.activeEnergyBurned.doubleValue(for: .kilocalorie())
            let exercise = summary.appleExerciseTime.doubleValue(for: .minute())
            let stand = summary.appleStandHours.doubleValue(for: .count())
            
            let moveGoal = summary.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
            let exerciseGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
            let standGoal = summary.appleStandHoursGoal.doubleValue(for: .count())
            
            DispatchQueue.main.async {
                completion(false, move, moveGoal, exercise, exerciseGoal, stand, standGoal)
            }
        }
        
        healthStore.execute(query)
    }
}
