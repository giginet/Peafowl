import Foundation

public enum WaitingForm {
    /// 両面待ち
    case bothSides
    /// 嵌張待ち
    case middleTile
    /// 辺張待ち
    case singleSide
    /// 単騎待ち
    case singleTile
    /// 双碰待ち
    case eitherOfMelds
}

struct WaitingFormDetector {
    func detect(from form: WinningForm, picked: Tile) -> Set<WaitingForm> {
        switch form {
        case .melded(let tokens):
            let eye = tokens.0
            let melds = TileUtility.melds(from: tokens)
            let containsInEye = eye.first == picked
            let containingMeld = melds.first { $0.contains(picked) }
            let containsInAnyMeld = containingMeld != nil

            switch (containsInEye, containsInAnyMeld) {
            case (true, true):
                return [.eitherOfMelds]
            case (true, false):
                return [.singleTile]
            case (false, true):
                return Set(melds.compactMap { (meld) -> WaitingForm? in
                    return meld.detectWaitingForm(with: picked)
                })
            case (false, false):
                fatalError("This condition should not be occured")
            }
        case .sevenPairs:
            return [.singleTile]
        case .thirteenOrphans:
            return [.singleTile]
        }
    }
}
