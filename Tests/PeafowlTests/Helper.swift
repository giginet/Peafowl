import Foundation
@testable import Peafowl

func makeContext(winningType: GameContext.WinningType = .selfPick,
                 pickedSource: GameContext.PickedSource = .wall,
                 riichiStyle: GameContext.RiichiStyle? = nil,
                 isOneShot: Bool = false,
                 isDealer: Bool = false,
                 isClosed: Bool = false,
                 prevalantWind: Tile = 東,
                 seatWind: Tile = 東,
                 dora: [Tile] = []) -> GameContext {
    return GameContext(winningType: winningType,
                       pickedSource: pickedSource,
                       riichiStyle: riichiStyle,
                       isOneShot: isOneShot,
                       isDealer: isDealer,
                       prevalantWind: prevalantWind,
                       seatWind: seatWind,
                       dora: dora)
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
            meld3.0, meld3.1, meld3.2,]
}
