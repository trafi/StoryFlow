import Foundation
import UIKit

extension OutputProducing where Self: UIViewController {

    var implicitFlow: Flow<OutputType> {
        return Flow { from, value in

            let (value, type) = unwrapped(value, OutputType.self)

            // MARK: Update

            if let to = from.unwindVc(for: type) {
                to.handleUpdate(value, type)
                Transition.unwind().go(from, to) // TODO: Custom transition
                return
            }

            // MARK: Input

            for inType in inputRequiringTypes where inType._inputType == type {
                let to = inType._create(input: value)
                from.show(to, sender: nil) // TODO: Custom transition
                return
            }

            fatalError("Didn't find `UpdateHandling` vc in the navigation sack and `InputRequiring` vc in the project for produced `output` \(value) from `\(Swift.type(of: from))`.")
        }
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
