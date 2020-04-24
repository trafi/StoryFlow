import Foundation
import UIKit

public protocol UpdateHandling: _AnyUpdateHandling {
    associatedtype UpdateType
    func handle(update: UpdateType)
}

extension UpdateHandling where Self: UIViewController {
    public func handle(update: UpdateType) {}
}
