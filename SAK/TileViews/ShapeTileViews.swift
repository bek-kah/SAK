import SwiftUI

struct SquareTileView: View {
    enum TileViewType {
        case weight(Weight)
        case activity(Activity)
        case none
    }
    
    var currentType: TileViewType = .none
    
    @Binding var selectedDay: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(.regularMaterial)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(15)
            
            switch currentType {
            case .weight(let weight):
                WeightTileView(weight: weight)
                
            case .activity(let activity):
                ActivityTileView(activity: activity)
                
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

