import XCTest
import StoryFlow

class FailureTests: XCTestCase {

    func testInputRequiring_itFailsAccessingInputBeforeItsSet() {

        // Arrange
        class Vc: UIViewController, InputRequiring { typealias InputType = Int }
        let vc = Vc()

        // Assert
        XCTAssertFatalError(vc.input)
    }

    func testInputRequiring_itFailsToBeCreate_whenInputTypeDoesntMatch() {

        // Arrange
        class Vc: UIViewController, InputRequiring { typealias InputType = Int }

        // Assert
        XCTAssertFatalError(Vc._create(input: ""))
    }

    func testUpdateHandling_itFailsToBeUpdated_whenUpdateTypeDoesntMatch() {

        // Arrange
        class Vc: UIViewController, UpdateHandling { func handle(update: Int) {} }
        let vc = Vc()

        // Assert
        XCTAssertFatalError(vc._handleAny(update: ""))
    }

    func testOuputProducing_itFailsToProduceOutput_whenNoUpdateHandlingForTypeIsFound() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, UpdateHandling { func handle(update: Int) {} }
        let from = From().visible()
        from.flow = .unwind()

        // Assert
        XCTAssertFatalError(from.produce(0))
    }

    func testOuputProducing_itFailsToProduceOutput_whenNoInputRequiringForTypeIsFound() {

        // Arrange
        class T {}
        class Vc: UIViewController, OutputProducing { typealias OutputType = T }
        let vc = Vc()

        // Assert
        XCTAssertFatalError(vc.produce(T()))
    }
}
