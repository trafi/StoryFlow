import Foundation
import UIKit

extension Flow {
        
    /**
     Returns view controller by matching type of provided `value`
     
     See [tests examples](https://github.com/trafi/StoryFlow/blob/master/StoryFlowTests/ImplicitFlowTests.swift).
     
     - Parameter value: The value being passed to next view controller.
     */
    public static func destination(for value: Value) -> UIViewController? {
        return destination(for: (value, Value.self))
    }
    
    private static func destination(for output: ValueAndType) -> UIViewController? {
        let (value, type) = OutputTransform.apply(output)

        let candidates = inputRequiringTypes.filter { oneOf($0._inputType, contains: type) }
        let supers = candidates.compactMap { class_getSuperclass($0 as? AnyClass) }

        let remainingCandidates = candidates.filter { c in
            let isSuper = supers.contains { s in s == (c as? AnyClass) }
            return !isSuper
        }

        for inType in remainingCandidates {
            return inType._create(input: value)
        }
        
        return nil
    }
    
}

extension Flow {

    private class _VoidOutputTypeProducing: UIViewController, OutputProducing {
        typealias OutputType = Void
    }
    
    public static func implicit() -> Flow {
        return Flow { from, value in

            let outputProducing = from as? _AnyOutputProducing ?? _VoidOutputTypeProducing()
            
            let output = OutputTransform.unwrapOneOfN((value, Swift.type(of: outputProducing)._outputType))
            let (value, type) = OutputTransform.apply(output)

            // MARK: Update

            if let to = from.unwindVc(for: type) {
                to.handleUpdate(value, type)
                let transition = TransitionInfo(from: from, producedType: output.type, receivedType: type, to: to, isUnwind: true)
                if CustomTransition.attempt(transition) == false {
                    Transition.unwind().go(from, to)
                }
                return
            }

            // MARK: Input
            
            if let to = Flow<Any>.destination(for: output) {
                let transition = TransitionInfo(from: from, producedType: output.type, receivedType: type, to: to, isUnwind: false)
                if CustomTransition.attempt(transition) == false {
                    Transition.show(UIViewController.self).go(from, to)
                }
                return
            }
            
            // MARK: Direct Unwind
            let directProduceType = Swift.type(of: value)
            
            if let to = from.unwindVc(for: directProduceType) {
                to.handleUpdate(value, directProduceType)
                let transition = TransitionInfo(from: from, producedType: directProduceType, receivedType: directProduceType, to: to, isUnwind: true)
                if CustomTransition.attempt(transition) == false {
                    Transition.unwind().go(from, to)
                }
                return
            }
            
            // MARK: Direct Input
            
            if let to = Flow<Any>.destination(for: (value, directProduceType)) {
                let transition = TransitionInfo(from: from, producedType: directProduceType, receivedType: directProduceType, to: to, isUnwind: false)
                if CustomTransition.attempt(transition) == false {
                    Transition.show(UIViewController.self).go(from, to)
                }
                return
            }

            fatalError("Didn't find `UpdateHandling` vc in the navigation stack and `InputRequiring` vc in the project for produced `output` \(value) from `\(Swift.type(of: from))`.")
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
