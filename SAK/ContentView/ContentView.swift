import SwiftData
import SwiftUI
internal import Combine

struct ContentView: View {

    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
           let viewModel = ViewModel(modelContext: modelContext)
           _viewModel = State(initialValue: viewModel)
       }

    var body: some View {
        NavigationStack {
            DashboardView(
                modelContext: viewModel.modelContext,
                healthStore: viewModel.healthStore,
                selectedDay: $viewModel.selectedDay,
                currentWeekIndex: $viewModel.currentWeekIndex,
                refresh: $viewModel.refresh
            )
            .navigationTitle("fit-tick")
            .sheet(isPresented: $viewModel.showDatePicker) {
                DatePicker(
                    "Select Date",
                    selection: $viewModel.selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .padding()
            }
            .sheet(isPresented: $viewModel.showNewWorkoutView) {
                NewWorkoutView(
                    modelContext: viewModel.modelContext,
                    selectedDay: viewModel.selectedDay
                ) {
                    viewModel.refresh.toggle()
                }
            }
            .sheet(isPresented: $viewModel.showNewWeightView) {
                NewWeightView {
                    viewModel.refresh.toggle()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(viewModel.selectedDateText) {
                        Button("Today", systemImage: "location.fill") {
                            viewModel.goToToday()
                        }
                        Button("Select Date", systemImage: "calendar") {
                            viewModel.showDatePicker = true
                        }
                    }
                    .font(.system(size: 15, weight: .medium))
                    .fontWidth(.expanded)
                    .foregroundStyle(.primary)
                }

                ToolbarSpacer(placement: .topBarTrailing)

                ToolbarItem(placement: .topBarTrailing) {
                    Menu("", systemImage: "plus") {
                        Button("New Workout", systemImage: "figure.strengthtraining.traditional") {
                            viewModel.showNewWorkoutView = true
                        }
                        Button("Record Weight", systemImage: "figure") {
                            viewModel.showNewWeightView = true
                        }
                    }
                }
            }
        }
        .onAppear(perform: viewModel.requestHealthKitAccess)
        .onChange(of: viewModel.selectedDate) { _, newDate in
            viewModel.onDateChanged(newDate)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Workout.self, WorkoutSession.self, configurations: config)

    ContentView(modelContext: container.mainContext)
        .modelContainer(container)
}
