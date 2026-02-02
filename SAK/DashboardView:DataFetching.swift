import SwiftUI

extension DashboardView {
    func weekdayString(forOffset offset: Int) -> String {
        let date = getSelectedDate(offset)

        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }

    func initialFetch() {
        loadWorkoutSession()
        fetchWeight()
        fetchActivitySummary()
    }

    func fetchWeight() {
        healthStore.fetchWeight(selectedDay: getSelectedDate(selectedDay)) { weight, date, userEntered in
            self.weight = Weight(value: weight,
                                 date: date,
                                 wasUserEntered: userEntered)
        }
    }

    func fetchActivitySummary() {
        healthStore.fetchActivitySummary(selectedDay: getSelectedDate(selectedDay)) { noData, move, moveGoal, exercise, exerciseGoal, stand, standGoal in
            self.activity = Activity(noData: noData,
                                     move: move,
                                     moveGoal: moveGoal,
                                     exercise: exercise,
                                     exerciseGoal: exerciseGoal,
                                     stand: stand,
                                     standGoal: standGoal)
        }
    }
}
