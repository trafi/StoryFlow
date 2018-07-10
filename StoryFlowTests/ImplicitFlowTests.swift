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
        container.addChildViewController(to)
        container.view.addSubview(to.view)
        to.didMove(toParentViewController: container)

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
}
