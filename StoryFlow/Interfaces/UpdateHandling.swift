import Foundation

public protocol UpdateHandling: _AnyUpdateHandling {
    associatedtype UpdateType
    func handle(update: UpdateType)
}
