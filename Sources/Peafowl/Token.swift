import Foundation

public struct Token<Tiles> {
    var tiles: Tiles
}

/// 面子
public typealias SetToken = Token<(Tile, Tile, Tile)>

/// 対子
public typealias PairToken = Token<(Tile, Tile)>

public extension Token where Tiles == (Tile, Tile) {
    /// 雀頭
    public var isHead: Bool {
        return tiles.0 == tiles.1
    }
}

public extension Token where Tiles == (Tile, Tile, Tile) {
    /// 刻子
    public var isPung: Bool {
        return tiles.0 == tiles.1
            && tiles.1 == tiles.2
            && tiles.2 == tiles.0
    }
    
    /// 順子
    public var isChow: Bool {
        let sorted = [tiles.0, tiles.1, tiles.2].sorted()
        switch (sorted[0], sorted[1], sorted[2]) {
        case (.character(let a), .character(let b), .character(let c)),
             (.bamboo(let a), .bamboo(let b), .bamboo(let c)),
             (.dots(let a), .dots(let b), .dots(let c)):
            return a + 1 == b && b + 1 == c
        default:
            return false
        }
    }
}

internal extension Token where Tiles == (Tile, Tile) {
    var asArray: [Tile] {
        return [tiles.0, tiles.1].sorted()
    }
}

internal extension Token where Tiles == (Tile, Tile, Tile) {
    var asArray: [Tile] {
        return [tiles.0, tiles.1, tiles.2].sorted()
    }
    
    func consistOnly(of filter: (Tile) -> Bool) -> Bool {
        return asArray.filter(filter).count == asArray.count
    }
}
