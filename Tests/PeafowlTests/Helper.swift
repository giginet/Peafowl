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
                       isRiichi: false,
                       isOneShot: false,
                       isDealer: false,
                       isClosed: true)
}

func makeHand(_ eye: (Tile, Tile),
              _ meld0: (Tile, Tile, Tile),
              _ meld1: (Tile, Tile, Tile),
              _ meld2: (Tile, Tile, Tile),
              _ meld3: (Tile, Tile, Tile)) -> Hand {
    return [eye.0, eye.1,
            meld0.0, meld0.1, meld0.2,
            meld1.0, meld1.1, meld1.2,
            meld2.0, meld2.1, meld2.2,
            meld3.0, meld3.1, meld3.2]
}
