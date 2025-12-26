import SwiftUI

struct StackedActivityRingViewConfig {
    var lineWidth: CGFloat = 20.0
    var outterRingColor: Color = .red
    var middleRingColor: Color = .green
    var innerRingColor: Color = .blue
}

struct StackedActivityRingView: View {
    private var outterRingValue: CGFloat
    private var middleRingValue: CGFloat
    private var innerRingValue: CGFloat
    
    private var scale: CGFloat
    
    init(outterRingValue: CGFloat, middleRingValue: CGFloat, innerRingValue: CGFloat, size: CGFloat, scale: CGFloat) {
        self.outterRingValue = outterRingValue
        self.middleRingValue = middleRingValue
        self.innerRingValue = innerRingValue
        self.width = size * scale
        self.height = size * scale
        self.scale = scale
    }
    
    var config: StackedActivityRingViewConfig = .init()
    var width: CGFloat
    var height: CGFloat
    
    var outerWidth: CGFloat { width }
    var outerHeight: CGFloat { height }
    var middleWidth: CGFloat { abs(width - (2 * config.lineWidth * scale)) }
    var middleHeight: CGFloat { abs(height - (2 * config.lineWidth * scale)) }
    var innerWidth: CGFloat { abs(width - (4 * config.lineWidth * scale)) }
    var innerHeight: CGFloat { abs(height - (4 * config.lineWidth * scale)) }
    
    var body: some View {
        ZStack {
            ActivityRingView(
                progress: outterRingValue,
                mainColor: config.outterRingColor,
                lineWidth: config.lineWidth,
                scale: scale
            )
            .frame(width: outerWidth, height: outerHeight)
            ActivityRingView(
                progress: middleRingValue,
                mainColor: config.middleRingColor,
                lineWidth: config.lineWidth,
                scale: scale
            )
            .frame(width: middleWidth, height: middleHeight)
            ActivityRingView(
                progress: innerRingValue,
                mainColor: config.innerRingColor,
                lineWidth: config.lineWidth,
                scale: scale
            )
            .frame(width: innerWidth, height: innerHeight)
        }
    }
}

#Preview {
    StackedActivityRingView(outterRingValue: 0.5, middleRingValue: 0.5, innerRingValue: 0.5, size: 200, scale: 1)
}
