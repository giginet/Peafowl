import Foundation

extension Sequence where Element: Equatable {
    func countIf(_ predicate: (Element) -> Bool) -> Int {
        return filter(predicate).count
    }

    func countIf(_ element: Element) -> Int {
        return countIf { return $0 == element }
    }
}
