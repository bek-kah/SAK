import SwiftUI

struct ActivityProgressView: View {
    private var moveProgess: Double
    private var exerciseProgress: Double
    private var standProgress: Double
    
    private var moveColor: Color
    private var exerciseColor: Color
    private var standColor: Color
    
    @State private var progress: CGFloat = 0.2
    
    init(moveProgess: Double = 0.0,
         exerciseProgress: Double = 0.0,
         standProgress: Double = 0.0,
         moveColor: Color = .pink,
         exerciseColor: Color = .green,
         standColor: Color = .blue
    ) {
        self.moveProgess = moveProgess
        self.exerciseProgress = exerciseProgress
        self.standProgress = standProgress
        self.moveColor = moveColor
        self.exerciseColor = exerciseColor
        self.standColor = standColor
    }
    
    var body: some View {
        ZStack {
            ActivityRingView(progress: $progress)
        }
    }
}

#Preview {
    ActivityProgressView()
}
