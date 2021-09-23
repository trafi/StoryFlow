import UIKit
import OneOfUs

extension OutputProducing where Self: UIViewController, OutputType: _OneOf2Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf3Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf4Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf5Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf6Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf7Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
    public func produce(_ output: OutputType.T7) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf8Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
    public func produce(_ output: OutputType.T7) { produce(.value(output)) }
    public func produce(_ output: OutputType.T8) { produce(.value(output)) }
}
