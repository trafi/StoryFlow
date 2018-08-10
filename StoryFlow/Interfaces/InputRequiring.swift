import Foundation
import UIKit

public protocol InputRequiring: _AnyInputRequiring {
    associatedtype InputType
}

extension InputRequiring where Self: UIViewController {

    /**
     Returns the produced `output` of a previous view controller.

     - precondition: View controller instance must be created using `produce(output:)` or `init(nibName:bundle:input)`. Otherwise, accessing this member causes a crash.
     */
    public internal(set) var input: InputType {
        get {
            let associatedInput: InputType? = associated(with: &inputKey)
            guard let input = associatedInput
                else { fatalError("Accessing unavailable `input` of `\(type(of: self))`. Make sure this view controller was created using `produce(output:)` or `init(nibName:bundle:input)`") }
            return input
        }
        nonmutating set {
            associate(newValue, with: &inputKey)
        }
    }
}

private var inputKey = 0
