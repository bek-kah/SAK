import SwiftUI

struct ActivityTileView: View {
    let activity: Activity
    
    var moveProgress: Double {
        activity.moveGoal > 0 ? activity.move / activity.moveGoal : 0
    }
    var exerciseProgress: Double {
        activity.exerciseGoal > 0 ? activity.exercise / activity.exerciseGoal : 0
    }
    var standProgress: Double {
        activity.standGoal > 0 ? activity.stand / activity.standGoal : 0
    }
    
    var moveText: String {
        if activity.noData {
            return "--/--"
        }
        return "\(Int(activity.move))/\(Int(activity.moveGoal))"
    }
    var exerciseText: String {
        if activity.noData {
            return "--/--"
        }
        return "\(Int(activity.exercise))/\(Int(activity.exerciseGoal))"
    }
    var standText: String {
        if activity.noData {
            return "--/--"
        }
        return "\(Int(activity.stand))/\(Int(activity.standGoal))"
    }
    
    @State private var showDetails: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height) * (2/3)
            Button {
                showDetails.toggle()
            } label: {
                if showDetails {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(moveText)
                                .font(.system(size: 17, weight: .bold))
                                .id(moveText)
                            Text("cals")
                                .font(.system(size: 15, weight: .regular))
                                .tint(.secondary)
                        }
                        HStack {
                            Text(exerciseText)
                                .font(.system(size: 17, weight: .bold))
                                .id(exerciseText)
                            Text("mins")
                                .font(.system(size: 15, weight: .regular))
                                .tint(.secondary)
                        }
                        HStack {
                            Text(standText)
                                .font(.system(size: 17, weight: .bold))
                                .id(standText)
                            Text("hrs")
                                .font(.system(size: 15, weight: .regular))
                                .tint(.secondary)
                        }
                    }
                    .animation(.default, value: activity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .fontWidth(.expanded)
                    .tint(.primary)
                } else {
                    StackedActivityRingView(
                        outterRingValue: moveProgress.isNaN ? 0 : moveProgress,
                        middleRingValue: exerciseProgress.isNaN ? 0 : exerciseProgress,
                        innerRingValue: standProgress.isNaN ? 0 : standProgress,
                        size: size,
                        scale: 1
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
}

