import Foundation

public protocol Token: Hashable, CustomStringConvertible {
    associatedtype Tiles
    var tiles: Tiles { get }
    init?(_ tiles: Tiles)
    var asArray: [Tile] { get }
}

/// 雀頭
public struct EyesToken: Token {
    public static func == (lhs: EyesToken, rhs: EyesToken) -> Bool {
        return lhs.tiles.0 == rhs.tiles.0 && lhs.tiles.1 == rhs.tiles.1
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tiles.0)
        hasher.combine(tiles.1)
    }
    
    public let tiles: Tiles
    
    public typealias Tiles = (Tile, Tile)

    public init?(_ tiles: Tiles) {
        self.tiles = tiles
        guard tiles.0 == tiles.1 else {
            return nil
        }
    }
    
    public var asArray: [Tile] {
        return [tiles.0, tiles.1].sorted()
    }
    
    public var description: String {
        return "雀頭 (\(tiles.0), \(tiles.1))"
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
    
    func consistOnly(of filter: (Tile) -> Bool) -> Bool {
        return asArray.filter(filter).count == asArray.count
    }
    
    public var description: String {
        if isTriplets {
            return "刻子 (\(tiles.0), \(tiles.1), \(tiles.2)"
        } else {
            return "順子 (\(tiles.0), \(tiles.1), \(tiles.2)"
        }
    }
}
