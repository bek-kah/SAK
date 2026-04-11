import HealthKitUI
import SwiftUI

struct NewWeightView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: Bool
    
    @State private var viewModel = ViewModel()
    
    private var refreshWeight: () -> Void
    
    init(refreshWeight: @escaping () -> Void) {
        self.refreshWeight = refreshWeight
    }
    
    var body: some View {
        NavigationStack {
            List {
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                DatePicker("Time", selection: $viewModel.date, displayedComponents: .hourAndMinute)
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField("lbs", value: $viewModel.pounds, format: .number)
                        .keyboardType(.decimalPad)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField)
                }
            }
            .navigationTitle("Record Weight")
            .font(.system(size: 15, weight: .regular))
            .fontWidth(.expanded)
            .foregroundStyle(.secondary)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark", role: .cancel) {
                        viewModel.addWeight(completion: refreshWeight)
                        dismiss()
                    }
                    .disabled(viewModel.pounds == nil || !viewModel.accessGranted)
                }
            }
            .onAppear() {
                viewModel.requestHealthAccess()
                focusedField = true
            }
            .healthDataAccessRequest(
                store: viewModel.healthStore,
                shareTypes: viewModel.weightType,
                readTypes: viewModel.weightType,
                trigger: viewModel.trigger) { result in
                    viewModel.handleAuthResult(result)
                }
        }
    }
}

#Preview {
    NewWeightView(refreshWeight: {})
}
