import Foundation

public extension Int {
    public var 萬: Tile? {
        return Tile(.character(self))
    }
    
    public var 筒: Tile? {
        return Tile(.dots(self))
    }
    
    public var 索: Tile? {
        return Tile(.bamboo(self))
    }
}
