import Foundation

public enum Tile: Equatable, Comparable {
    public static func < (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.index < rhs.index
    }
    
    private var index: Int {
        switch self {
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
    /// 撥
    case fortune
    /// 中
    case center
}
