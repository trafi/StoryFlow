import Foundation
import UIKit

public struct Flow<Value> {
    let go: (UIViewController, Value) -> ()
    func proceed(with output: Value, from vc: UIViewController) {
        go(vc, output)
    }
}

// MARK: - Initializers

extension Flow {

    public init<C: UIViewController & InputRequiring>(_ transition: Transition<C>)
        where Value == C.InputType {
            go = { from, value in
                let to = C.init()
                to.input = value
                transition.go(from, to)
            }
    }

    public init<C: UIViewController & IO>(_ transition: Transition<C>, _ flow: Flow<C.OutputType>)
        where Value == C.InputType {
            go = { from, value in
                let to = C.init()
                to.input = value
                to.flow = flow
                transition.go(from, to)
            }
    }

    // MARK: Show

    public static func show<C: UIViewController & InputRequiring>(_: C.Type) -> Flow
        where Value == C.InputType {
            return Flow(.show(C.self))
    }

    public static func show<C: UIViewController & IO>(_: C.Type, _ flow: Flow<C.OutputType>) -> Flow
        where Value == C.InputType {
            return Flow(.show(C.self), flow)
    }

    // MARK: Present

    public static func present<C: UIViewController & InputRequiring>(_: C.Type) -> Flow
        where Value == C.InputType {
            return Flow(.present(C.self))
    }

    public static func present<C: UIViewController & IO>(_: C.Type, _ flow: Flow<C.OutputType>) -> Flow
        where Value == C.InputType {
            return Flow(.present(C.self), flow)
    }

    // MARK: Unwind

    public static func unwind() -> Flow {
        return self.init { from, value in
            guard let to = from.unwindVc(for: Value.self)
                else { fatalError("Didn't find `UpdateHandling` vc when unwinding from `\(self)` with `output` value: \(value).") }
            to.handleUpdate(value, Value.self)
            Transition.unwind().go(from, to)
        }
    }
}
