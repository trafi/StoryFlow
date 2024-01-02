import Foundation
import UIKit

extension InputRequiring where Self: UIViewController {

    public init(nibName: String? = nil, bundle: Bundle? = nil, input: InputType) {
        self.init(nibName: nibName, bundle: bundle)
        self.input = input
    }
}

extension OutputProducing where Self: UIViewController {

    /// - Parameters:
    ///   - produceStub: Closure that optionally overrides default produce behavior.
    ///   When nil is returned default produce behaviour will not be triggered.
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        produceStub: @escaping (OutputType) -> OutputType?
    ) {
        self.init(nibName: nibName, bundle: bundle)
        self.produceStub = produceStub
    }
    
    /// - Parameters:
    ///   - produceStub: Closure that overrides default produce behavior.
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        produceStub: @escaping (OutputType) -> ()
    ) {
        self.init(nibName: nibName, bundle: bundle) {
            produceStub($0)
            return nil
        }
    }

    var produceStub: ((OutputType) -> OutputType?)? {
        get { return associated(with: &produceStubKey) }
        set { associate(newValue, with: &produceStubKey) }
    }
}
private var produceStubKey = 0

extension InputRequiring where Self: UIViewController & OutputProducing {

    /// - Parameters:
    ///   - produceStub: Closure that optionally overrides default produce behavior.
    ///   When nil is returned default produce behaviour will not be triggered.
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        input: InputType,
        produceStub: @escaping (OutputType) -> OutputType?
    ) {
        self.init(nibName: nibName, bundle: bundle)
        self.input = input
        self.produceStub = produceStub
    }
    
    /// - Parameters:
    ///   - produceStub: Closure that overrides default produce behavior.
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        input: InputType,
        produceStub: @escaping (OutputType) -> ()
    ) {
        self.init(nibName: nibName, bundle: bundle) {
            produceStub($0)
            return nil
        }
    }
    
}
