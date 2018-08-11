import Foundation

extension Sequence where Element: Equatable {
    func count(_ isMatched: (Element) -> Bool) -> Int {
        return filter(isMatched).count
    }

    func count(_ element: Element) -> Int {
        return count { return $0 == element }
    }
}
