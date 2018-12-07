import Foundation
import UIKit

extension Flow {

    public static func implicit() -> Flow {
        return Flow { from, value in

            guard let outputProducing = from as? _AnyOutputProducing
                else { fatalError("Can't use `Flow.implict()` on vc that is not `OutputProducing` for produced `output` \(value) from `\(Swift.type(of: from))`.") }

            let outputType = Swift.type(of: outputProducing)._outputType
            let (value, type) = unwrapped(value, outputType)

            // MARK: Update

            if let to = from.unwindVc(for: type) {
                to.handleUpdate(value, type)
                if CustomTransition.attempt(from: from, to: to) == false {
                    Transition.unwind().go(from, to)
                }
                return
            }

            // MARK: Input

            for inType in inputRequiringTypes where inType._inputType == type {
                let to = inType._create(input: value)
                if CustomTransition.attempt(from: from, to: to) == false {
                    from.show(to, sender: nil)
                }
                return
            }

            fatalError("Didn't find `UpdateHandling` vc in the navigation sack and `InputRequiring` vc in the project for produced `output` \(value) from `\(Swift.type(of: from))`.")
        }
    }
}

extension OutputProducing where Self: UIViewController {

    var implicitFlow: Flow<OutputType> {
        return .implicit()
    }
}

private var inputRequiringTypes: [_AnyInputRequiring.Type] = {

    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
    let actualClassCount = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    var classes = [_AnyInputRequiring.Type]()

    Thread.onMain {
        for i in 0 ..< actualClassCount {
            let c: AnyClass = allClasses[Int(i)]
            guard
                class_getSuperclass(c) is UIViewController.Type,
                let t = c as? _AnyInputRequiring.Type
                else { continue }

            classes.append(t)
        }
    }

    allClasses.deallocate()

    return classes
}()
