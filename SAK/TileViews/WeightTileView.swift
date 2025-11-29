import SwiftUI

struct WeightTileView: View {
    let weight: Double
    let weightDate: Date
    
    var body: some View {
        VStack {
            Text("\(weight, specifier: "%.1f") lbs")
                .font(.system(size: 20, weight: .bold))
                .fontWidth(.expanded)

            Text(weightDate.formatted(.relative(presentation: .named)))
                .font(.system(size: 14, weight: .regular))
                .fontWidth(.expanded)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
