import SwiftUI

struct DaysScrollView: View {
    @Binding private var currentWeekIndex: Int?
    @Binding private var selectedDay: Int
    
    @State private var viewModel = ViewModel()
    
    init(
        selectedDay: Binding<Int>,
        currentWeekIndex: Binding<Int?>
    ) {
        self._selectedDay = selectedDay
        self._currentWeekIndex = currentWeekIndex
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<7, id: \.self) { dayIndex in
                    let dayName = String(viewModel.daySymbols[dayIndex].prefix(1))
                    Text(dayName)
                        .font(.system(size: 14, weight: .bold))
                        .fontWidth(.expanded)
                        .foregroundStyle(dayIndex == 0 || dayIndex == 6 ? .secondary : .primary)
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
                                        .foregroundStyle(viewModel.dayColor(index, selectedDay))
                                    
                                    Button {
                                        selectedDay = index
                                    } label: {
                                        Text("\(dayNumber)")
                                            .font(.system(size: 14, weight: selectedDay == index ? .regular : .light))
                                            .fontWidth(.expanded)
                                            .foregroundStyle(viewModel.dayTextColor(index, dayIndex, selectedDay))
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
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentWeekIndex)
        }
        .padding(.top)
        .padding(.horizontal)
        .onChange(of: currentWeekIndex) {
            let newWeekIndex = currentWeekIndex ?? 52
            let difference = newWeekIndex - (selectedDay / 7)
            selectedDay = selectedDay + difference * 7
        }
    }
}

#Preview {
    DaysScrollView(
        selectedDay: .constant(52 * 7 + Calendar.current.component(.weekday, from: Date()) - 1),
        currentWeekIndex: .constant(52)
    )
}


