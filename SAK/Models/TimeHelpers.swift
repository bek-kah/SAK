import Foundation

let constantSelectedDay: Int = 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1

var weeks: [[Date]] {
    let calendar = Calendar.current
    let today = Date()
    let startOfCurrentWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
    
    return (-52..<52).map { weekOffset in
        let weekStart = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: startOfCurrentWeek) ?? startOfCurrentWeek
        
        return (0..<7).compactMap { dayOffset in
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                return nil
            }
            
            let startOfDay = calendar.startOfDay(for: day)
            if let nextDay = calendar.date(byAdding: .day, value: 1, to: startOfDay),
               let endOfDay = calendar.date(byAdding: .second, value: -1, to: nextDay) {
                return endOfDay
            }
            return day
        }
    }
}

func getSelectedDate(_ index: Int) -> Date {
    guard weeks.indices.contains(index / 7) else { return Date() }
    guard weeks[index / 7].indices.contains(index % 7) else { return Date() }
    
    //    print("showing \(weeks[index / 7][index % 7].formatted())")
    return weeks[index / 7][index % 7]
}

func getSelectedDay(_ day: Date) -> Int {
    let calendar = Calendar.current
    for (weekIndex, week) in weeks.enumerated() {
        for (dayIndex, date) in week.enumerated() {
            if calendar.isDate(date, inSameDayAs: day) {
                return weekIndex * 7 + dayIndex
            }
        }
    }
    return 52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1 // fallback to today
}

func getWeekdayIndex(_ index: Int) -> Int {
    let date = getSelectedDate(index)
    
    let calendar = Calendar.current
    return calendar.component(.weekday, from: date) - 1
}
