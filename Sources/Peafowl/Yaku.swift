import Foundation

/// 役
public protocol YakuProtocol: Hashable {
    var name: String { get }
    /// 翻
    var closedHan: Int { get }
    /// 喰い下がり翻
    var openedHan: Int? { get }
    var isYakuman: Bool { get }
    static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> Self?
}

public extension YakuProtocol {
    var openedHan: Int? {
        return 0
    }
    
    var isYakuman: Bool {
        return closedHan >= 13
    }
}

private class BoxBase: YakuProtocol {
    static func == (lhs: BoxBase, rhs: BoxBase) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        fatalError("Not implemented")
    }
    
    var closedHan: Int {
        fatalError("Not implemented")
    }
    
    var openedHan: Int? {
        fatalError("Not implemented")
    }
    
    var name: String {
        fatalError("Not implemented")
    }
    
    static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> Self? {
        fatalError("Not implemented")
    }
}

public struct AnyYaku: YakuProtocol {
    public static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> AnyYaku? {
        fatalError("Could not make AnyYaku")
    }
    
    public typealias Form = Void
    private let box: BoxBase
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(box.name)
    }
    
    internal init<Yaku>(_ yaku: Yaku) where Yaku: YakuProtocol {
        self.box = Box(yaku)
    }
    
    public var name: String {
        return box.name
    }
    
    public var closedHan: Int {
        return box.closedHan
    }
    
    private class Box<Yaku>: BoxBase where Yaku: YakuProtocol {
        private let internalYaku: Yaku
        init(_ yaku: Yaku) {
            self.internalYaku = yaku
        }
        
        override var closedHan: Int {
            return internalYaku.closedHan
        }
        
        override var openedHan: Int? {
            return internalYaku.openedHan
        }
        
        override var name: String {
            return internalYaku.name
        }
    }
}
