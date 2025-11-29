import SwiftUI

struct ActivityTileView: View {
    let moveProgress: Double
    let exerciseProgress: Double
    let standProgress: Double
    
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height) * (2/3)
            VStack {
                StackedActivityRingView(
                    outterRingValue: moveProgress.isNaN ? 0 : moveProgress,
                    middleRingValue: exerciseProgress.isNaN ? 0 : exerciseProgress,
                    innerRingValue: standProgress.isNaN ? 0 : standProgress,
                    size: size
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
