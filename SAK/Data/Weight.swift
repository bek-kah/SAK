import Foundation

/// Here the date variable is an optional so if an error has occured or the user does not have a weight for that date, it is set to nil.

struct Weight {
    var value: Double
    var date: Date?
    var wasUserEntered: Bool
}
