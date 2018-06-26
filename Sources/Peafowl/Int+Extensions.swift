import Foundation

public extension Int {
    public var 萬: Tile? {
        return .character(self)
    }
    
    public var 筒: Tile? {
        return .dots(self)
    }
    
    public var 索: Tile? {
        return .bamboo(self)
    }
}
