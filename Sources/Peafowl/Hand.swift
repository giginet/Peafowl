import Foundation

public struct Hand: Equatable {
    var drawed: Tile?
    var tiles: [Tile]
    
    public var isValid: Bool {
        return drawed != nil && tiles.count == 13
    }
}
