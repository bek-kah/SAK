import SwiftUI

struct SquareTileView: View {
    enum TileViewType {
        case weight(Double, Date, Bool)
        case activity(Double, Double, Double)
        case workout(Workout)
        case none
    }
    
    var currentType: TileViewType = .none
    
    var removeWorkout: ((Workout) -> Void)?
    
    @Binding var selectedDay: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if case .workout = currentType {
                Rectangle()
                    .fill(.regularMaterial)
                    .cornerRadius(15)
            } else {
                Rectangle()
                    .fill(.regularMaterial)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(15)
            }
            
            switch currentType {
            case .weight(let weight, let weightDate, _):
                WeightTileView(weight: weight, weightDate: weightDate)
                
            case .activity(let moveProgress, let exerciseProgress, let standProgress):
                ActivityTileView(moveProgress: moveProgress, exerciseProgress: exerciseProgress, standProgress: standProgress)
                
                
            case .workout(let workout):
                WorkoutTileView(workout: workout, removeWorkout: removeWorkout ?? { _ in })
                
            case .none:
                Text("")
            }
        }
    }
}

struct CircleTileView: View {
    var body: some View {
        Capsule()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: .infinity)
    }
}

struct RectangleTileView: View {
    var body: some View {
        Rectangle()
            .aspectRatio(4/5, contentMode: .fit)
            .frame(maxWidth: .infinity)
    }
}


#Preview {
    SquareTileView(
        currentType: .workout(.fake),
        removeWorkout: { _ in },
        selectedDay: .constant(1)
    )
}

