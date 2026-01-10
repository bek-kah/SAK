import SwiftUI

private var weeks: [[Date]] {
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
    
    print("showing \(weeks[index / 7][index % 7].formatted())")
    return weeks[index / 7][index % 7]
}

struct DaysScrollView: View {
    @State private var currentWeek: [Date]? = []
    @State private var currentWeekIndex: Int?
    private let daySymbols = Calendar.current.shortWeekdaySymbols
    
    var weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    private var currentDay: Int {
        52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1
    }
    @Binding private var selectedDay: Int
    
    init(selectedDay: Binding<Int>) {
        self._selectedDay = selectedDay
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<7, id: \.self) { dayIndex in
                    let dayName = String(daySymbols[dayIndex].prefix(1))
                    Text(dayName)
                        .font(.system(size: 14, weight: .bold))
                        .fontWidth(.expanded)
                        .foregroundStyle(isSaturdayOrSunday(dayIndex) ? .secondary : .primary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(weeks.enumerated(), id: \.offset) { weekIndex, week in
                        HStack {
                            ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, date in
                                let dayNumber = Calendar.current.component(.day, from: date)
                                let index = weekIndex * 7 + dayIndex
                                ZStack {
                                    CircleTileView()
                                        .foregroundStyle(
                                            index == selectedDay && index == currentDay ? .red :
                                                selectedDay == index ? .primary : .clear
                                        )
                                    
                                    Button {
                                        selectedDay = index
                                    } label: {
                                        Text("\(dayNumber)")
                                            .font(.system(size: 14, weight: selectedDay == index ? .regular : .light))
                                            .fontWidth(.expanded)
                                            .foregroundStyle(dayTextColor(index, dayIndex))
                                    }
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                        .id(weekIndex)
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentWeekIndex)
            .scrollIndicators(.hidden)
        }
        .padding(.top)
        .padding(.horizontal)
        .onAppear {
            if currentWeekIndex == nil {
                currentWeekIndex = 52
            }
        }
    }
    
    func isSaturdayOrSunday(_ index: Int) -> Bool {
        index == 0 || index == 6
    }
    
    func dayTextColor(_ index: Int, _ dayIndex: Int) -> Color {
        let isSelectedDay = index == selectedDay
        let isCurrentDay = index == currentDay
        let isWeekendDay = isSaturdayOrSunday(dayIndex)
        
        if isSelectedDay {
            return .white
        } else if isCurrentDay {
            return .red
        } else {
            return isWeekendDay ? .secondary : .primary
        }
    }
    
    func getMonth() -> String {
        guard let idx = currentWeekIndex, weeks.indices.contains(idx),
              let firstDate = weeks[idx].first,
              let lastDate = weeks[idx].last
        else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "LLLL"
        
        let firstMonth = formatter.string(from: firstDate)
        let lastMonth = formatter.string(from: lastDate)
        
        if firstMonth == lastMonth {
            return firstMonth
        } else {
            return firstMonth + "-" + lastMonth
        }

    }
}

#Preview {
    DaysScrollView(selectedDay: .constant(52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1))
}


