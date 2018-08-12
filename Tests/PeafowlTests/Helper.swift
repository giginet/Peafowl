import Foundation
@testable import Peafowl

extension Hand: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Tile
    
    public init(arrayLiteral elements: Hand.ArrayLiteralElement...) {
        let picked = elements.last!
        self = .init(tiles: Array<Hand.ArrayLiteralElement>(elements.dropLast()), picked: picked)
    }
}

func makeContext() -> GameContext {
    return GameContext(winningType: .selfPick,
                       pickedSource: .wall,
                       isOneShot: false,
                       isDealer: false,
                       isClosed: true)
}
