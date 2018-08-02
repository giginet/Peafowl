import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func removeFirst(_ element: Element) -> Element? {
        guard let index = firstIndex(of: element) else { return nil }
        return remove(at: index)
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set<Element>(self))
    }
}
