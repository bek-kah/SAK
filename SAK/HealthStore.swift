import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()
    
    // request permissions
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
    
    // Fetch step count data from HealthKit
    func fetchStepCount(completion: @escaping (Double) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: [.strictStartDate])
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
            DispatchQueue.main.async {
                completion(stepCount)
            }
        }
        healthStore.execute(query)
    }
    
    // Fetch weight date from HealthKit
    func fetchWeight(
        selectedDate: Date = Date(),
        completion: @escaping (
            _ pounds: Double,
            _ date: Date?,
            _ wasUserEntered: Bool
        ) -> Void) {
        let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: selectedDate, options: [])
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: weightType,
                                  predicate: predicate,
                                  limit: 1,
                                  sortDescriptors: [sort]) { _, samples, error in
            guard error == nil, let sample = samples?.first as? HKQuantitySample else {
                DispatchQueue.main.async { completion(0, nil, false) } // No data
                return
            }

            let pounds = sample.quantity.doubleValue(for: .pound())
            let date = sample.endDate // or sample.startDate
            let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false

            DispatchQueue.main.async {
                completion(pounds, date, wasUserEntered)
            }
        }

        healthStore.execute(query)
    }
    
    // Fetch today's activity summary from HealthKit
    func fetchTodayActivitySummary(
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

            // Values
            let move = summary.activeEnergyBurned.doubleValue(for: .kilocalorie())
            let exercise = summary.appleExerciseTime.doubleValue(for: .minute())
            let stand = summary.appleStandHours.doubleValue(for: .count())

            // Goals
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
