import SwiftUI

private var weekDates: [Date] {
    let calendar = Calendar.current
    let today = Date()
    let weekday = calendar.component(.weekday, from: today)
    let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!
    return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
}

func getSelectedDate(_ selectedDay: Int) -> Date {
    guard weekDates.indices.contains(selectedDay) else { return Date() }
    return weekDates[selectedDay]
}

struct DaysScrollView: View {
    private var currentDay: Int = Calendar.current.component(.weekday, from: Date()) - 1
    @Binding private var selectedDay: Int
    
    init(selectedDay: Binding<Int>) {
        self._selectedDay = selectedDay
    }
    
    private let daySymbols = Calendar.current.shortWeekdaySymbols
    
    var body: some View {
        HStack {
            ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                let dayName = String(daySymbols[index].prefix(1))
                let dayNumber = Calendar.current.component(.day, from: date)
                
                VStack {
                    Text(dayName)
                        .font(.system(size: 14, weight: .bold))
                        .fontWidth(.expanded)
                        .foregroundStyle(isSaturdayOrSunday(index) ? .secondary : .primary)
                    
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
                                .foregroundStyle(
                                    selectedDay == index ? Color(uiColor: .systemBackground) : (currentDay == index ? .red : isSaturdayOrSunday(index) ? .secondary : .primary)
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top)
    }
    
    func isSaturdayOrSunday(_ index: Int) -> Bool {
        index == 0 || index == 6
    }
}

#Preview {
    DaysScrollView(selectedDay: .constant(1))
}

