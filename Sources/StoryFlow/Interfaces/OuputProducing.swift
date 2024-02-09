import Foundation
import UIKit

public protocol OutputProducing: _AnyOutputProducing {
    associatedtype OutputType
}

extension OutputProducing where Self: UIViewController {

    /**
     Transitions to view controller in the `flow` by matching the type of provided `output`.

     Possible transitions:
     - Unwind back to `UpdateHandling` view controller in the hierarchy.
     - Create and show new `InputRequiring` view controller.

     See [tests examples](https://github.com/trafi/StoryFlow/blob/master/StoryFlowTests/ImplicitFlowTests.swift).

     - Parameter output: The value being passed to next view controller.
     */
    public func produce(_ output: OutputType) {
        if let produceStub {
            if let customOutput = produceStub(output) {
                _produce(customOutput)
            }
        } else {
            _produce(output)
        }
    }
    
    private func _produce(_ output: OutputType) {
        if let flow = flow {
            flow.proceed(with: output, from: self)
        } else {
            implicitFlow.proceed(with: output, from: self)
        }
    }
    
    public func produceDirect<T>(_ output: T) {
        Flow<T>.implicit().proceed(with: output, from: self)
    }

    /**
     Explicit transition graph from view controller.

     See [test examples](https://github.com/trafi/StoryFlow/blob/master/StoryFlowTests/ExplicitFlowTests.swift).
     */
    public var flow: Flow<OutputType>? {
        get {
            return associated(with: &flowKey)
        }
        nonmutating set {
            associate(newValue, with: &flowKey)
        }
    }
}

private var flowKey = 0


public extension UIViewController {
    
    func produceDirect<T>(_ output: T) {
        Flow<T>.implicit().proceed(with: output, from: self)
    }
    
}
