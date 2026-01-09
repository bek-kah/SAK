import SwiftUI

struct WeightTileView: View {
    let weight: Weight

    var body: some View {
        return VStack {
            if let weightDate = weight.date {
                Text("\(weight.value, specifier: "%.1f") lbs")
                    .font(.system(size: 20, weight: .bold))
                    .fontWidth(.expanded)

                Text(weightDate.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 14, weight: .regular))
                    .fontWidth(.expanded)
                    .foregroundStyle(.secondary)
            } else {
                
                Text("Click '+' above to record you weight")
                    .font(.system(size: 14, weight: .regular))
                    .fontWidth(.expanded)
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

