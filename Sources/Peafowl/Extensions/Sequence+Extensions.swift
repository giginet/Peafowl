import Foundation

extension Sequence where Element: Equatable {
    func countIf(_ predicate: (Element) -> Bool) -> Int {
        return filter(predicate).count
    }

    func countIf(_ element: Element) -> Int {
        return countIf { return $0 == element }
    }
}

extension Sequence where Element: Comparable {
    func max() -> Element? {
        guard let initialResult = first(where: { _ in true }) else {
            return nil
        }
        return reduce(initialResult) { previous, next in
            return previous < next ? next : previous
        }
    }
}
