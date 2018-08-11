import Foundation

public struct AnyYakuType {
    private let makeBlock: ([Tile], WinningForm?, Tile) -> AnyYaku?
    
    init<Yaku>(_: Yaku.Type) where Yaku: YakuProtocol {
        makeBlock = { tiles, form, drawed in
            guard let innerYaku = Yaku.make(with: tiles, form: form, drawed: drawed) else {
                return nil
            }
            return AnyYaku(innerYaku)
        }
    }
    
    func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> AnyYaku? {
        return makeBlock(tiles, form, drawed)
    }
}

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

public struct AnyYaku: YakuProtocol {
    public static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> AnyYaku? {
        fatalError("Could not make AnyYaku")
    }
    
    public typealias Form = Void
    private let box: BaseBox
    
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
    
    private class BaseBox: YakuProtocol {
        static func == (lhs: BaseBox, rhs: BaseBox) -> Bool {
            fatalError("Not implemented")
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
    
    private class Box<Yaku>: BaseBox where Yaku: YakuProtocol {
        fileprivate let internalYaku: Yaku
        
        init(_ yaku: Yaku) {
            self.internalYaku = yaku
        }
        
        static func == (lhs: Box, rhs: Box) -> Bool {
            return type(of: lhs.internalYaku) == type(of: rhs.internalYaku)
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
