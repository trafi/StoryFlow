import Foundation
import UIKit

public struct Transition<To: UIViewController> {
    let go: (UIViewController, To) -> ()
}

// MARK: - Initializers

extension Transition {

    public static func custom(_: To.Type, transition: @escaping (UIViewController, To) -> ()) -> Transition {
        return Transition(go: transition)
    }

    public static func show(_: To.Type) -> Transition {
        return Transition { $0.show($1, sender: nil) }
    }

    public static func present(_: To.Type, animated: Bool = true) -> Transition {
        return Transition { $0.present($1, animated: animated) }
    }
}

extension Transition where To == UIViewController {

    public static func unwind(animated: Bool = true) -> Transition {
        return Transition {
            if $1.presentedViewController != nil {
                $1.navigationController?.popToViewController($1, animated: false)
                $1.dismiss(animated: animated, completion: nil)
            } else {
                $1.navigationController?.popToViewController($1, animated: animated)
            }
        }
    }
}
