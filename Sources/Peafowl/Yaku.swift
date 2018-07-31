import Foundation

/// 役
public protocol Yaku {
    associatedtype Form
    
    /// 翻
    var closedHan: Int { get }
    /// 喰い下がり翻
    var openedHan: Int? { get }
    var isYakuman: Bool { get }
    static func make(with tiles: Form, drawed: Tile) -> Self?
}

public extension Yaku {
    var openedHan: Int? {
        return 0
    }
    
    var isYakuman: Bool {
        return closedHan >= 13
    }
}
