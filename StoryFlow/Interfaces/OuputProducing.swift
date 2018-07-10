import Foundation
import UIKit

public protocol OutputProducing: _AnyOutputProducing {
    associatedtype OutputType
}

extension OutputProducing where Self: UIViewController {

    public func produce(_ output: OutputType) {

        if let produce = produceStub {
            produce(output)
        } else if let flow = flow {
            flow.proceed(with: output, from: self)
        } else {
            implicitFlow.proceed(with: output, from: self)
        }
    }

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
