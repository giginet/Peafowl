import Foundation

public protocol Yaku {
    var openedHan: Int { get }
    var closedHan: Int? { get }
    func validate(with hand: Hand) -> Bool
}

public extension Yaku {
    var closedHan: Int? {
        return 0
    }
}
