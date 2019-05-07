import Foundation
import UIKit

public struct TransitionInfo {
    public let from: UIViewController
    public let producedType: Any.Type
    public let receivedType: Any.Type
    public let to: UIViewController
    public let isUnwind: Bool
}
public typealias TransitionAttempt = (TransitionInfo) -> Bool

public enum CustomTransition {

    // MARK: Registering

    public static func register(transitionAttempt: @escaping TransitionAttempt) {
        attempts.append(transitionAttempt)
    }

    public static func register<To: UIViewController>(transition: Transition<To>) {
        register(fromType: UIViewController.self, transition: transition)
    }

    public static func register<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { info in
            guard
                info.isUnwind == false,
                info.from is From,
                let to = info.to as? To
            else { return false }

            transition.go(info.from, to)
            return true
        }
    }

    public static func register<InputType>(for inputType: InputType.Type, transition: Transition<UIViewController>) {
        register { info in
            guard
                info.producedType == inputType,
                info.isUnwind == false
            else { return false }

            transition.go(info.from, info.to)
            return true
        }
    }

    public static func registerUnwind<From: UIViewController, To: UIViewController>(fromType: From.Type, transition: Transition<To>) {
        register { info in
            guard
                info.isUnwind == true,
                info.from is From,
                let to = info.to as? To
            else { return false }

            transition.go(info.from, to)
            return true
        }
    }

    // MARK: Attempting

    static var attempts = [TransitionAttempt]()

    static func attempt(_ transition: TransitionInfo) -> Bool {
        return attempts.contains { $0(transition) == true }
    }
}
