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

            for vcType in vcTypes {
                guard let inType = vcType as? _AnyInputRequiring.Type, inType._inputType == type
                    else { continue }

                let to = inType._create(input: value)
                from.show(to, sender: nil) // TODO: Custom transition
                return
            }

            fatalError("Didn't find `UpdateHandling` vc in the navigation sack and `InputRequiring` vc in the project for produced `output` \(value) from `\(Swift.type(of: from))`.")
        }
    }
}

private var vcTypes: [AnyClass] = _findVcTypes()

func _findVcTypes() -> [AnyClass] {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
    let actualClassCount = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    var classes = [AnyClass]()
    for i in 0 ..< actualClassCount {
        let c: AnyClass = allClasses[Int(i)]
        guard
            class_getSuperclass(c) is UIViewController.Type,
            c is _AnyOutputProducing.Type ||
            c is _AnyInputRequiring.Type ||
            c is _AnyUpdateHandling.Type
        else { continue }

        classes.append(c)
    }
    allClasses.deallocate()

    return classes
}
