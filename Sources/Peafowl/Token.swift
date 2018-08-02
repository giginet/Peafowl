import Foundation

public protocol Token: Hashable {
    associatedtype Tiles
    var tiles: Tiles { get }
    init?(tiles: Tiles)
    var asArray: [Tile] { get }
}

public struct PairToken: Token {
    public static func == (lhs: PairToken, rhs: PairToken) -> Bool {
        return lhs.tiles.0 == rhs.tiles.0 && lhs.tiles.1 == rhs.tiles.1
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tiles.0)
        hasher.combine(tiles.1)
    }
    
    public let tiles: Tiles
    
    public typealias Tiles = (Tile, Tile)

    public init?(tiles: Tiles) {
        self.tiles = tiles
        guard isEyes else {
            return nil
        }
    }
    
    /// 雀頭
    public var isEyes: Bool {
        return tiles.0 == tiles.1
    }
    
    public var asArray: [Tile] {
        return [tiles.0, tiles.1].sorted()
    }
}

public struct SetToken: Token {
    public static func == (lhs: SetToken, rhs: SetToken) -> Bool {
        return lhs.tiles.0 == rhs.tiles.0 && lhs.tiles.1 == rhs.tiles.1 && lhs.tiles.2 == rhs.tiles.2
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(tiles.0)
        hasher.combine(tiles.1)
        hasher.combine(tiles.2)
    }
    
    public let tiles: Tiles
    
    public typealias Tiles = (Tile, Tile, Tile)
    
    public init?(tiles: Tiles) {
        self.tiles = tiles
        guard isMelds || isChow else {
            return nil
        }
    }
    
    /// 刻子
    public var isMelds: Bool {
        return tiles.0 == tiles.1
            && tiles.1 == tiles.2
            && tiles.2 == tiles.0
    }
    
    /// 順子
    public var isChow: Bool {
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
}
