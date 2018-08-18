import Foundation

public struct Tile: Equatable, Comparable, Hashable {
    public static func character(_ number: Int) -> Tile? {
        return Tile(.character(number))
    }
    public static func bamboo(_ number: Int) -> Tile? {
        return Tile(.bamboo(number))
    }
    public static func dots(_ number: Int) -> Tile? {
        return Tile(.dots(number))
    }
    public static let east = Tile(.east)!
    public static let west = Tile(.west)!
    public static let south = Tile(.south)!
    public static let north = Tile(.north)!
    public static let blank = Tile(.blank)!
    public static let fortune = Tile(.fortune)!
    public static let center = Tile(.center)!

    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        switch (lhs.suit, rhs.suit) {
        case (.character(let n), .character(let m)),
             (.bamboo(let n), .bamboo(let m)),
             (.dots(let n), .dots(let m)):
            return n == m
        case (.east, .east),
             (.west, .west),
             (.south, .south),
             (.north, .north),
             (.blank, .blank),
             (.fortune, .fortune),
             (.center, .center):
            return true
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }

    public let suit: Suit

    public enum Suit {
        /// 萬子
        case character(Int)
        /// 索子
        case bamboo(Int)
        /// 筒子
        case dots(Int)
        /// 東
        case east
        /// 南
        case south
        /// 西
        case west
        /// 北
        case north
        /// 白
        case blank
        /// 發
        case fortune
        /// 中
        case center
    }

    public init?(_ suit: Suit) {
        switch suit {
        case .character(let n), .bamboo(let n), .dots(let n):
            if n <= 0 || n > 9 {
                return nil
            }
        default: break
        }
        self.suit = suit
    }

    public static func < (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.index < rhs.index
    }

    private var index: Int {
        switch suit {
        case .character(let n): return n + 9 * 0
        case .bamboo(let n): return n + 9 * 1
        case .dots(let n): return n + 9 * 2
        case .east: return 28
        case .south: return 29
        case .west: return 30
        case .north: return 31
        case .blank: return 32
        case .fortune: return 33
        case .center: return 34
        }
    }

    /// 数牌
    public var isSimple: Bool {
        switch suit {
        case .character, .dots, .bamboo:
            return true
        default:
            return false
        }
    }

    /// 字牌
    public var isHonor: Bool {
        return !isSimple
    }

    /// 風牌
    public var isWind: Bool {
        switch suit {
        case .east, .south, .west, .north:
            return true
        default:
            return false
        }
    }

    /// 三元牌
    public var isDragon: Bool {
        switch suit {
        case .blank, .fortune, .center:
            return true
        default:
            return false
        }
    }

    /// 端牌
    public var isTerminal: Bool {
        switch suit {
        case .dots(let n), .character(let n), .bamboo(let n):
            return n == 1 || n == 9
        default:
            return false
        }
    }
    
    public var isGreen: Bool {
        switch suit {
        case .bamboo(let n) where [2, 3, 4, 6, 8].contains { $0 == n }:
            return true
        case .fortune:
            return true
        default:
            return false
        }
    }
    
    public var isYaochu: Bool {
        return isTerminal || isHonor
    }

    public var number: Int? {
        switch suit {
        case .dots(let n), .character(let n), .bamboo(let n):
            return n
        default:
            return nil
        }
    }

    private func advanced(by successor: Int) -> Tile? {
        switch suit {
        case .dots(let n):
            return Tile(.dots(n + successor))
        case .character(let n):
            return Tile(.character(n + successor))
        case .bamboo(let n):
            return Tile(.bamboo(n + successor))
        default:
            return nil
        }
    }

    public var next: Tile? {
        return advanced(by: 1)
    }

    public var previous: Tile? {
        return advanced(by: -1)
    }
    
    public var isCharacter: Bool {
        if case .character = suit {
            return true
        }
        return false
    }
    
    public var isBamboo: Bool {
        if case .bamboo = suit {
            return true
        }
        return false
    }
    
    public var isDots: Bool {
        if case .dots = suit {
            return true
        }
        return false
    }
}

extension Tile: CustomStringConvertible {
    public var description: String {
        switch suit {
        case .character(let n):
            return "\(n)萬"
        case .bamboo(let n):
            return "\(n)索"
        case .dots(let n):
            return "\(n)筒"
        case .east: return "東"
        case .south: return "南"
        case .west: return "西"
        case .north: return "北"
        case .blank: return "白"
        case .fortune: return "發"
        case .center: return "中"
        }
    }
}
