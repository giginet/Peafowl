import Foundation

public struct AnyYakuType {
    private let makeBlock: ([Tile], WinningForm, Tile, GameContext) -> AnyYaku?

    init<Yaku>(_: Yaku.Type) where Yaku: YakuProtocol {
        makeBlock = { tiles, form, picked, context in
            guard let innerYaku = Yaku.make(with: tiles, form: form, picked: picked, context: context) else {
                return nil
            }
            return AnyYaku(innerYaku)
        }
    }

    func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> AnyYaku? {
        return makeBlock(tiles, form, picked, context)
    }
}

/// 役
public protocol YakuProtocol: Hashable, CustomStringConvertible {
    var name: String { get }
    /// 翻
    var concealedFan: Int { get }
    /// 喰い下がり翻
    var openedFan: Int? { get }
    var isYakuman: Bool { get }
    static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> Self?
}

public extension YakuProtocol {
    var openedFan: Int? {
        return 0
    }

    var isYakuman: Bool {
        return concealedFan >= 13
    }

    var description: String {
        return name
    }
}

public struct AnyYaku: YakuProtocol, CustomStringConvertible {
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> AnyYaku? {
        fatalError("Could not make AnyYaku")
    }

    public typealias Form = Void
    private let box: BaseBox

    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: box.yakuClass))
    }

    internal init<Yaku>(_ yaku: Yaku) where Yaku: YakuProtocol {
        self.box = Box(yaku)
    }

    public var name: String {
        return box.name
    }

    public var concealedFan: Int {
        return box.concealedFan
    }

    private class BaseBox: YakuProtocol {
        static func == (lhs: BaseBox, rhs: BaseBox) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }

        func hash(into hasher: inout Hasher) {
            fatalError("Not implemented")
        }

        var concealedFan: Int {
            fatalError("Not implemented")
        }

        var openedFan: Int? {
            fatalError("Not implemented")
        }

        var name: String {
            fatalError("Not implemented")
        }

        fileprivate var yakuClass: Any.Type? {
            fatalError("Not implemeted")
        }

        static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> Self? {
            fatalError("Not implemented")
        }
    }

    private class Box<Yaku>: BaseBox where Yaku: YakuProtocol {
        fileprivate let internalYaku: Yaku

        init(_ yaku: Yaku) {
            self.internalYaku = yaku
        }

        override var yakuClass: Any.Type? {
            return Swift.type(of: internalYaku)
        }

        override var concealedFan: Int {
            return internalYaku.concealedFan
        }

        override var openedFan: Int? {
            return internalYaku.openedFan
        }

        override var name: String {
            return internalYaku.name
        }

        override func hash(into hasher: inout Hasher) {
            internalYaku.hash(into: &hasher)
        }
    }

    public func type<Yaku: YakuProtocol>(of yakuClass: Yaku.Type) -> Bool {
        return box.yakuClass == yakuClass
    }
}
