import Foundation

extension YakuProtocol {
    static func melds(from winningForm: MeldedWinningForm) -> [MeldToken] {
        return [winningForm.1, winningForm.2, winningForm.3, winningForm.4]
    }
}
