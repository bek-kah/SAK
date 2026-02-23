import HealthKitUI
import SwiftUI

struct NewWeightView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var pounds: Double?
    @State private var date: Date = .now
    
    var healthStore = HKHealthStore()
    
    let weightType: Set = [
        HKQuantityType.quantityType(forIdentifier: .bodyMass)!
    ]
    
    @State var accessRequested = false
    @State var trigger = false
    
    var body: some View {
        NavigationStack {
            List {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField("lbs", value: $pounds, format: .number)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.trailing)
                }
            }
            .navigationTitle("New Weight")
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
                        addWeight()
                        dismiss()
                    }
                    .disabled(pounds == nil || !accessRequested)
                }
            }
            .onAppear() {
                if HKHealthStore.isHealthDataAvailable() {
                    trigger.toggle()
                }
            }
            
            .healthDataAccessRequest(store: healthStore,
                                             shareTypes: weightType,
                                             readTypes: weightType,
                                             trigger: trigger) { result in
                        switch result {
                            
                        case .success(_):
                            accessRequested = true
                        case .failure(let error):
                            // Handle the error here.
                            fatalError("*** An error occurred while requesting authentication: \(error) ***")
                        }
                    }
        }
    }
    
    
    func addWeight() {
        let healthStore = HKHealthStore()
        
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        if let pounds = pounds {
            let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
            let quantity = HKQuantity(unit: .pound(), doubleValue: pounds)
            let sample = HKQuantitySample(type: weightType, quantity: quantity, start: date, end: date)
            
            healthStore.save(sample) { success, error in
                if success {
                    print("Successfully saved weight.")
                } else {
                    print("Error saving weight: \(String(describing: error))")
                }
                
            }
        }
    }
}

#Preview {
    NewWeightView()
}
