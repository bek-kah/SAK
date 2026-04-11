import Foundation
import SwiftUI

extension DaysScrollView {
    @Observable
    class ViewModel {
        private var currentWeek: [Date]? = []
        let daySymbols = Calendar.current.shortWeekdaySymbols
        var weekDays = ["S", "M", "T", "W", "T", "F", "S"]
        var currentDay: Int {
            52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
        }
        
        func dayColor(
            _ index: Int,
            _ selectedDay: Int
        ) -> Color {
            index == selectedDay && index == currentDay ? .red :
                selectedDay == index ? .primary : .clear
        }
        
        func dayTextColor(
            _ index: Int,
            _ dayIndex: Int,
            _ selectedDay: Int
        ) -> Color {
            let isSelectedDay = index == selectedDay
            let isCurrentDay = index == currentDay
            let isWeekendDay = dayIndex == 0 || dayIndex == 6
                    
            if isSelectedDay {
                return Color(uiColor: .systemBackground)
            }
            
            if isCurrentDay {
                return .red
            }
            
            if isWeekendDay {
                return .secondary
            } else {
                return .primary
            }
        }
    }
}
