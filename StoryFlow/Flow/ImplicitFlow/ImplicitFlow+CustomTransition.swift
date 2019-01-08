import Foundation
import UIKit

public enum CustomTransition {

    // MARK: Register transitions

    public static func register(transitionAttempt: @escaping ((UIViewController, UIViewController) -> Bool)) {
        attempts.append(transitionAttempt)
    }

    public static func register<To: UIViewController>(transition: Transition<To>) {
        register(fromType: UIViewController.self, transition: transition)
    }

    public static func register<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { from, to in
            guard
                from is From,
                let to = to as? To
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    public static func register<InputType>(for inputType: InputType.Type, transition: Transition<UIViewController>) {
        register { from, to in
            guard
                let anyTo = to as? _AnyInputRequiring,
                oneOf(type(of: anyTo)._inputType, contains: inputType)
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    // MARK: Attempting

    static var attempts = [(UIViewController, UIViewController) -> Bool]()

    static func attempt(from: UIViewController, to: UIViewController) -> Bool {
        return attempts.contains { $0(from, to) == true }
    }
}
