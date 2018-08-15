import Foundation

public protocol Token: Hashable, CustomStringConvertible {
    associatedtype Tiles
    var tiles: Tiles { get }
    init?(_ tiles: Tiles)
    var asArray: [Tile] { get }
}

public struct AnyToken: Token {
    public let tiles: [Tile]
    public typealias Tiles = [Tile]

    public init?(_ tiles: [Tile]) {
        self.tiles = tiles
    }

    public var asArray: [Tile] {
        return tiles
    }

    public var description: String {
        return String(describing: tiles)
    }
}

/// 対子、塔子
public struct PairToken: Token {
    public typealias Tiles = (Tile, Tile)
    public let tiles: Tiles

    public init?(_ tiles: Tiles) {
        self.tiles = tiles
        if waitingTilesForMeld() == nil {
            return nil
        }
    }

    public var description: String {
        if isEyes {
            return "雀頭 (\(tiles.0), \(tiles.1))"
        } else {
            return "塔子 (\(tiles.0), \(tiles.1))"
        }
    }

    public static func == (lhs: PairToken, rhs: PairToken) -> Bool {
        return lhs.tiles.0 == rhs.tiles.0 && lhs.tiles.1 == rhs.tiles.1
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(tiles.0)
        hasher.combine(tiles.1)
    }

    public var asArray: [Tile] {
        return [tiles.0, tiles.1].sorted()
    }

    /// 対子
    public var isEyes: Bool {
        return tiles.0 == tiles.1
    }

    public func waitingTilesForMeld() -> Set<Tile>? {
        guard let firstTile = asArray.first, let secondTile = asArray.last else {
            return nil
        }
        if isEyes {
            return [firstTile]
        }
        switch (firstTile.suit, secondTile.suit) {
        case (.character(let n), .character(let m)),
             (.bamboo(let n), .bamboo(let m)),
             (.dots(let n), .dots(let m)):
            if m - n == 1 {
                return Set([firstTile.previous, secondTile.next].compactMap { $0 })
            } else if m - n == 2 {
                return Set([firstTile.next].compactMap { $0 })
            }
        default:
            return nil
        }

        return nil
    }
}

/// 面子
public struct MeldToken: Token {
    public static func == (lhs: MeldToken, rhs: MeldToken) -> Bool {
        return lhs.tiles.0 == rhs.tiles.0 && lhs.tiles.1 == rhs.tiles.1 && lhs.tiles.2 == rhs.tiles.2
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(tiles.0)
        hasher.combine(tiles.1)
        hasher.combine(tiles.2)
    }

    public let tiles: Tiles

    public typealias Tiles = (Tile, Tile, Tile)

    public init?(_ tiles: Tiles) {
        self.tiles = tiles
        guard isTriplets || isSequential else {
            return nil
        }
    }

    /// 刻子
    public var isTriplets: Bool {
        return tiles.0 == tiles.1
            && tiles.1 == tiles.2
            && tiles.2 == tiles.0
    }

    /// 順子
    public var isSequential: Bool {
        let sorted = [tiles.0, tiles.1, tiles.2].sorted()
        switch (sorted[0].suit, sorted[1].suit, sorted[2].suit) {
        case (.character(let a), .character(let b), .character(let c)),
             (.bamboo(let a), .bamboo(let b), .bamboo(let c)),
             (.dots(let a), .dots(let b), .dots(let c)):
            return a + 1 == b && b + 1 == c
        default:
            return false
        }
    }

    public var asArray: [Tile] {
        return [tiles.0, tiles.1, tiles.2].sorted()
    }

    public var description: String {
        if isTriplets {
            return "刻子 (\(tiles.0), \(tiles.1), \(tiles.2)"
        } else {
            return "順子 (\(tiles.0), \(tiles.1), \(tiles.2)"
        }
    }
    
    internal var isCharacter: Bool {
        return tiles.0.isCharacter && tiles.1.isCharacter && tiles.2.isCharacter
    }
    
    internal var isBamboo: Bool {
        return tiles.0.isBamboo && tiles.1.isBamboo && tiles.2.isBamboo
    }
    
    internal var isDots: Bool {
        return tiles.0.isDots && tiles.1.isDots && tiles.2.isDots
    }
}
