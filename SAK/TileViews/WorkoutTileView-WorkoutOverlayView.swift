import SwiftUI

extension WorkoutTileView {
    var workoutOverlayView: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            
            VStack {
                Text("\(workout.name) is")
                    .font(.system(size: 17, weight: .regular))
                    .fontWidth(.expanded)
                Text("Complete!")
                    .font(.system(size: 17, weight: .bold))
                    .fontWidth(.expanded)
            }
            
            Button {
                hideOverlay = true
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
                    .font(.system(size: 25))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
        }
    }
}
