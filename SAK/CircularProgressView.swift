import SwiftUI

struct CircularProgressView: View {
    private var color: Color
    private var size: CGFloat
    private var progress: Double
    var colors: [Color] = [Color.darkRed, Color.lightRed]
    
    
    init(color: Color, size: CGFloat, progress: Double) {
        self.color = color
        self.size = size
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.65),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                ).rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    CircularProgressView(color: .pink, size: 200, progress: 1.2)
}


extension Color {
    public static var outlineRed: Color {
        return Color(decimalRed: 34, green: 0, blue: 3)
    }
    
    public static var darkRed: Color {
        return Color(decimalRed: 221, green: 31, blue: 59)
    }
    
    public static var lightRed: Color {
        return Color(decimalRed: 239, green: 54, blue: 128)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
