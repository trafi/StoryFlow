import Foundation
import UIKit

public typealias IsUnwind = Bool
public typealias TransitionAttempt = (UIViewController, Any.Type, UIViewController, IsUnwind) -> Bool

public enum CustomTransition {

    // MARK: Registering

    public static func register(transitionAttempt: @escaping TransitionAttempt) {
        attempts.append(transitionAttempt)
    }

    public static func register<To: UIViewController>(transition: Transition<To>) {
        register(fromType: UIViewController.self, transition: transition)
    }

    public static func register<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { from, _, to, isUnwind in
            guard
                isUnwind == false,
                from is From,
                let to = to as? To
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    public static func register<InputType>(for inputType: InputType.Type, transition: Transition<UIViewController>) {
        register { from, outputType, to, isUnwind in
            guard
                outputType == inputType,
                isUnwind == false
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    public static func registerUnwind<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { from, _, to, isUnwind in
            guard
                isUnwind == true,
                from is From,
                let to = to as? To
            else { return false }

            transition.go(from, to)
            return true
        }
    }

    // MARK: Attempting

    static var attempts = [TransitionAttempt]()

    static func attempt(from: UIViewController, outputType: Any.Type, to: UIViewController, isUnwind: Bool) -> Bool {
        return attempts.contains { $0(from, outputType, to, isUnwind) == true }
    }
}
