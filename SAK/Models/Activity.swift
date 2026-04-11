import Foundation

struct Activity: Equatable {
    var noData: Bool
    var move: Double
    var moveGoal: Double
    var exercise: Double
    var exerciseGoal: Double
    var stand: Double
    var standGoal: Double
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        let noDataSame = lhs.noData == rhs.noData
        let moveSame = lhs.move == rhs.move
        let moveGoalSame = lhs.moveGoal == rhs.moveGoal
        let exerciseSame = lhs.exercise == rhs.exercise
        let exerciseGoalSame = lhs.exerciseGoal == rhs.exerciseGoal
        let standSame = lhs.stand == rhs.stand
        let standGoalSame = lhs.standGoal == rhs.standGoal
        
        return noDataSame && moveSame && moveGoalSame && exerciseSame && exerciseGoalSame && standSame && standGoalSame
    }
}
