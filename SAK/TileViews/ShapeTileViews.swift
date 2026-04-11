import SwiftData
import SwiftUI

struct SquareTileView: View {
    enum TileViewType {
        case weight(Weight)
        case activity(Activity)
        case workout(
            ModelContext,
            Workout,
            WorkoutSession,
            (UUID, [WorkoutSession]) -> (),
            Binding<Bool>
        )
        case none
    }
    
    var currentType: TileViewType = .none
    
    var selectedDay: Int
    
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
            case .weight(let weight):
                WeightTileView(weight: weight)
                
            case .activity(let activity):
                ActivityTileView(activity: activity)
                
            case .workout(
                let modelContext,
                let workout,
                let session,
                let deleteSessions,
                let refresh
            ):
                WorkoutTileView(
                    modelContext: modelContext,
                    workout: workout,
                    workoutSession: session,
                    deleteSessions: deleteSessions,
                    refresh: refresh
                )
                
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

