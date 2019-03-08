import XCTest
import StoryFlow

class ImplicitFlowTests: XCTestCase {

    // MARK: Show

    func testProduce_itShowsNextVcAndPassesOutput() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, InputRequiring { typealias InputType = T }

        let from = From().visible()

        let output = T()

        // Act
        from.produce(output)

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input === output)
    }

    func testProduce_itShowsNextVcByOneOfOutputType() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = OneOf2<T1, T2> }
        class To1: UIViewController, InputRequiring { typealias InputType = T1 }
        class To2: UIViewController, InputRequiring { typealias InputType = T2 }

        let from = From().visible()

        // Act
        from.produce(T1())
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(currentVc is To1)
    }

    func testProduce_itShowsNextVcByOneOfInputType() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = T1 }
        class To: UIViewController, InputRequiring { typealias InputType = OneOf2<T1, T2> }

        let from = From().visible()

        // Act
        from.produce(T1())
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(currentVc is To)
    }

    // MARK: Unwind

    func testProduce_itUnwindsToUpdateHandlingVcAndPassesOutput() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling {
            func handle(update: T) { self.update = update }
            var update: T!
        }

        let to = To().visible()
        let from = From()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        let output = T()

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
        XCTAssert(to.update === output)
    }

    func testProduce_itUnwindsToOneOfUpdateHandlingVcAndPassesOutput() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = T1 }
        class To: UIViewController, UpdateHandling {
            func handle(update: OneOf2<T1, T2>) { self.update = update }
            var update: OneOf2<T1, T2>!
        }

        let to = To().visible()
        let from = From()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        let output = T1()

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
        guard case .t1(let update)? = to.update else { XCTFail(); return }
        XCTAssert(update === output)
    }

    func testProduce_itUnwindsToChildVcAndPassessOutput() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling {
            func handle(update: T) { self.update = update }
            var update: T!
        }

        let container = UIViewController().visible()
        let to = To()
        container.addChild(to)
        container.view.addSubview(to.view)
        to.didMove(toParent: container)

        let from = From()
        container.show(from, sender: nil)

        let output = T()

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == container)
        XCTAssert(to.update === output)

    }

    func testProduce_itPrioritizesUnwindingToShowing() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling { func handle(update: T) { } }
        class Bait: UIViewController, InputRequiring { typealias InputType = T }

        let to = To().visible()
        let from = From()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        // Act
        from.produce(T())
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
    }

    func testProduce_itUnwindsInNavigationStack() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling { func handle(update: T) { } }

        let to = To()
        UINavigationController(rootViewController: to).visible()

        to.show(UIViewController(), sender: nil)
        XCTAssert(currentVc.didAppear())

        let from = From()
        currentVc.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        // Act
        from.produce(T())
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
    }

    func testProduce_itUnwindsToParentAndPassessOutput() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling {
            func handle(update: T) { self.update = update }
            var update: T!
        }

        let to = To().visible()
        let from = From()

        to.addChild(from)

        let output = T()

        // Act
        from.produce(output)

        // Assert
        XCTAssert(currentVc == to)
        XCTAssert(to.update === output)
    }

    func testProduce_whenSelfCanHandleUpdate_itUnwindsToPreviousVc() {

        // Arrange
        class T {}

        class Vc: UIViewController, OutputProducing, UpdateHandling {
            typealias OutputType = T
            func handle(update: T) { self.update = update }
            var update: T?
        }

        let to = Vc()
        let from = Vc()

        let nav = UINavigationController()
        nav.setViewControllers([to, from], animated: false)
        nav.visible()

        let output = T()

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
        XCTAssert(to.update === output)
        XCTAssertNil(from.update)
        
    }

    func testProduce_itUnwindsInComplexFlow() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling { func handle(update: T) { } }

        let to = To()
        UINavigationController(rootViewController: to).visible()

        to.show(UIViewController(), sender: nil)
        XCTAssert(currentVc.didAppear())

        currentVc.show(UINavigationController(rootViewController: UIViewController()), sender: nil)
        XCTAssert(currentVc.didAppear())

        currentVc.show(UIViewController(), sender: nil)
        XCTAssert(currentVc.didAppear())

        let from = From()
        currentVc.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        // Act
        from.produce(T())
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
    }

    // MARK: Custom transition

    func testProduce_itUsesCustomTransitionAttempt() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, InputRequiring { typealias InputType = T }

        let from = From().visible()

        var customTransitionUsed = false

        CustomTransition.register(transitionAttempt: { _, _, _ in
            customTransitionUsed = true
            return true
        })

        // Act
        from.produce(T())

        // Assert
        XCTAssert(customTransitionUsed)

        // Clean up
        CustomTransition.reset()
    }

    func testProduce_itUsesCustomTransition() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, InputRequiring { typealias InputType = T }

        let from = From().visible()

        var customTransitionUsed = false

        CustomTransition.register(transition: Transition.custom(To.self) { _, _ in
            customTransitionUsed = true
        })

        // Act
        from.produce(T())

        // Assert
        XCTAssert(customTransitionUsed)

        // Clean up
        CustomTransition.reset()
    }

    func testProduce_itUsesCustomTransitionWithDefinedFrom() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, InputRequiring { typealias InputType = T }

        let from = From().visible()

        var customTransitionUsed = false

        CustomTransition.register(fromType: From.self, transition: Transition.custom(To.self) { _, _ in
            customTransitionUsed = true
        })

        // Act
        from.produce(T())

        // Assert
        XCTAssert(customTransitionUsed)

        // Clean up
        CustomTransition.reset()
    }

    func testProduce_itUsesCustomTransitionForInputType() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, InputRequiring { typealias InputType = T }

        let from = From().visible()

        var customTransitionUsed = false

        CustomTransition.register(for: T.self, transition: Transition.custom(UIViewController.self) { _, _ in
            customTransitionUsed = true
        })

        // Act
        from.produce(T())

        // Assert
        XCTAssert(customTransitionUsed)

        // Clean up
        CustomTransition.reset()
    }

    func testProduce_itUsesCustomTransitionForUnwind() {

        // Arrange
        class T {}

        class From: UIViewController, OutputProducing { typealias OutputType = T }
        class To: UIViewController, UpdateHandling { func handle(update: T) { } }

        let to = To().visible()
        let from = From()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        var customTransitionUsed = false

        CustomTransition.register(transitionAttempt: { _, _, _ in
            customTransitionUsed = true
            return true
        })

        // Act
        from.produce(T())

        // Assert
        XCTAssert(customTransitionUsed)

        // Clean up
        CustomTransition.reset()
    }

    // MARK: Output transforms

    func testProduce_itShowsNextVcByTransformedOutput() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = T1 }
        class To: UIViewController, InputRequiring { typealias InputType = T2 }

        let from = From().visible()
        let transformedOutput = T2()

        OutputTransform.register { (_: T1) in transformedOutput }

        // Act
        from.produce(T1())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input === transformedOutput)

        // Clean up
        OutputTransform.reset()
    }

    func testProduce_itShowsNextVcByApplyingSingleTransformedOutput() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = T1 }
        class To: UIViewController, InputRequiring { typealias InputType = T2 }

        let from = From().visible()
        let transformedOutput = T2()

        OutputTransform.register { (_: T1) in transformedOutput }
        OutputTransform.register { (_: T2) in "" }

        // Act
        from.produce(T1())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input === transformedOutput)

        // Clean up
        OutputTransform.reset()
    }

    func testProduce_itShowsNextVcByTransformedOneOfOutput() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = T1 }
        class To: UIViewController, InputRequiring { typealias InputType = T2 }

        let from = From().visible()
        let transformedOutput = T2()
        let oneOfTransformedOutput: OneOf2<T1, T2> = .t2(transformedOutput)

        OutputTransform.register { (_: T1) in oneOfTransformedOutput }

        // Act
        from.produce(T1())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input === transformedOutput)

        // Clean up
        OutputTransform.reset()
    }

    func testProduce_itShowsNextVcByOneOfTransformedOneOfOutput() {

        // Arrange
        class T1 {}
        class T2 {}

        class From: UIViewController, OutputProducing { typealias OutputType = OneOf2<T2, T1> }
        class To: UIViewController, InputRequiring { typealias InputType = T2 }

        let from = From().visible()
        let transformedOutput = T2()
        let oneOfTransformedOutput: OneOf2<T1, T2> = .t2(transformedOutput)

        OutputTransform.register { (_: T1) in oneOfTransformedOutput }

        // Act
        from.produce(T1())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input === transformedOutput)

        // Clean up
        OutputTransform.reset()
    }
}
