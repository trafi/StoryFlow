import Foundation
import UIKit

// MARK: - InputRequiring

@available(*, deprecated, message: "This is an internal StoryFlow interface.", renamed: "InputRequiring")
public protocol _AnyInputRequiring {
    static var _inputType: Any.Type { get }
    static func _create(input: Any) -> UIViewController
}

extension InputRequiring where Self: UIViewController  {

    public static var _inputType: Any.Type {
        return InputType.self
    }

    public static func _create(input: Any) -> UIViewController {
        guard let typedInput = input as? InputType
            else { fatalError("Trying to create `\(self)` with uncompatible `input` value: \(input).") }
        return self.init(input: typedInput)
    }
}

// MARK: - OutputProducing

@available(*, deprecated, message: "This is an internal StoryFlow interface.", renamed: "OutputProducing")
public protocol _AnyOutputProducing {
    static var _outputType: Any.Type { get }
    func _setFlow(_ f: Flow<Any>)
}

extension OutputProducing where Self: UIViewController {
    public static var _outputType: Any.Type {
        return OutputType.self
    }
    public func _setFlow(_ f: Flow<Any>) {
        flow = Flow(go: f.go)
    }
}

// MARK: UpdateHandling

@available(*, deprecated, message: "This is an internal StoryFlow interface.", renamed: "UpdateHandling")
public protocol _AnyUpdateHandling {
    static var _updateType: Any.Type { get }
    func _handleAny(update: Any)
}

extension UpdateHandling where Self: UIViewController {
    public static var _updateType: Any.Type {
        return UpdateType.self
    }
    public func _handleAny(update: Any) {
        if let update = update as? UpdateType {
            handle(update: update)
        } else if let update = (UpdateType.self as? OneOfNType.Type)?.create(from: update) as? UpdateType {
            handle(update: update)
        } else {
            fatalError("Trying to update `\(self)` with uncompatible `update` value: \(update).")
        }
    }
}
