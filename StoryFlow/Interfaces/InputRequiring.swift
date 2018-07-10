import Foundation
import UIKit

public protocol InputRequiring: _AnyInputRequiring {
    associatedtype InputType
}

extension InputRequiring where Self: UIViewController {

    public internal(set) var input: InputType {
        get {
            let associatedInput: InputType? = associated(with: &associatedKey)
            guard let input = associatedInput
                else { fatalError("Accessing `input` of `\(type(of: self))` before it was set.") }
            return input
        }
        nonmutating set {
            associate(newValue, with: &associatedKey)
        }
    }
}

private var associatedKey = 0
