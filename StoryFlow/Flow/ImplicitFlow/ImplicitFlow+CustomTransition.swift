import Foundation
import UIKit

public enum CustomTransition {

    // MARK: Register transitions

    public static func register(transitionAttempt: @escaping ((UIViewController, Any.Type, UIViewController) -> Bool)) {
        attempts.append(transitionAttempt)
    }

    public static func register<To: UIViewController>(transition: Transition<To>) {
        register(fromType: UIViewController.self, transition: transition)
    }

    public static func register<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { from, _, to in
            guard
                from is From,
                let to = to as? To
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    public static func register<InputType>(for inputType: InputType.Type, transition: Transition<UIViewController>) {
        register { from, outputType, to in
            guard outputType == inputType else { return false }

            transition.go(from, to)
            return true
        }
    }

    // MARK: Attempting

    static var attempts = [(UIViewController, Any.Type, UIViewController) -> Bool]()

    static func attempt(from: UIViewController, outputType: Any.Type, to: UIViewController) -> Bool {
        return attempts.contains { $0(from, outputType, to) == true }
    }
}
