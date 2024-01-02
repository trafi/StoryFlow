import Foundation
import UIKit

extension InputRequiring where Self: UIViewController {

    public init(nibName: String? = nil, bundle: Bundle? = nil, input: InputType) {
        self.init(nibName: nibName, bundle: bundle)
        self.input = input
    }
}

extension OutputProducing where Self: UIViewController {

    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        produce: @escaping (OutputType) -> OutputType?
    ) {
        self.init(nibName: nibName, bundle: bundle)
        produceStub = produce
    }
    
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        produce: @escaping (OutputType) -> ()
    ) {
        self.init(nibName: nibName, bundle: bundle) {
            produce($0)
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

    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        input: InputType,
        produce: @escaping (OutputType) -> OutputType?
    ) {
        self.init(nibName: nibName, bundle: bundle)
        self.input = input
        self.produceStub = produce
    }
    
    public init(
        nibName: String? = nil,
        bundle: Bundle? = nil,
        input: InputType,
        produce: @escaping (OutputType) -> ()
    ) {
        self.init(nibName: nibName, bundle: bundle) {
            produce($0)
            return nil
        }
    }
    
}
