import Foundation

extension Set where Element: Hashable {
    func inserted(_ element: Element) -> Set<Element> {
        var mutableSelf = self
        mutableSelf.insert(element)
        return mutableSelf
    }
}
