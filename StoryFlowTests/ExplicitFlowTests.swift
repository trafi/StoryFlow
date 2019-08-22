import XCTest
import StoryFlow

class ExplicitFlowTests: XCTestCase {

    // MARK: Show

    func testProduce_itShowsNextVcAndPassesOutput() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, InputRequiring { typealias InputType = Int }

        let from = From().visible()
        from.flow = .show(To.self)

        let output = 2018

        // Act
        from.produce(output)
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input == output)
    }

    func testProduce_itShowsNextVcAndPassesProtocolOutput() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = LinkType }
        class To: UIViewController, InputRequiring { typealias InputType = LinkType }

        let from = From().visible()
        from.flow = .show(To.self)

        let output = Link()

        // Act
        from.produce(output)
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input as! Link == output)
    }

    func testProduce_itShowsNextVcByOneOfOutputType() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = OneOf2<Int, String> }
        class ToInt: UIViewController, InputRequiring { typealias InputType = Int }
        class ToString: UIViewController, InputRequiring { typealias InputType = String }

        let from = From().visible()
        from.flow = Flow(
            .show(ToInt.self),
            .show(ToString.self)
        )

        // Act
        from.produce(0)
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(currentVc is ToInt)
    }

    func testProduce_isUsesCustomTransitionAndPassesOutput() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, InputRequiring { typealias InputType = Int }

        let from = From().visible()
        var transitionWasUsed = false
        from.flow = Flow(.custom(To.self, transition: { $0.show($1, sender: nil); transitionWasUsed = true }))

        let output = 0

        // Act
        from.produce(output)
        XCTAssert(currentVc.didAppear())

        // Assert
        XCTAssert(transitionWasUsed)
        XCTAssert(currentVc is To)
        XCTAssert((currentVc as! To).input == output)
    }

    // MARK: Unwind

    func testProduce_itUnwindsToUpdateHandlingVc() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, UpdateHandling { typealias UpdateType = Int }

        let to = To().visible()
        let from = From()
        from.flow = .unwind()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        // Act
        from.produce(2018)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
    }

    func testProduce_itUnwindsToUpdateHandlingVcAndPassesOutput() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, UpdateHandling {
            func handle(update: Int) { self.update = update }
            var update: Int!
        }

        let to = To().visible()
        let from = From()
        from.flow = .unwind()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        let output = 2018

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
        XCTAssert(to.update == output)
    }

    func testProduce_itUnwindsToOneOfUpdateHandlingVcAndPassesOutput() {

        // Arrange
        class From: UIViewController, OutputProducing { typealias OutputType = Int }
        class To: UIViewController, UpdateHandling {
            func handle(update: OneOf2<Int, String>) { self.update = update }
            var update: OneOf2<Int, String>!
        }

        let to = To().visible()
        let from = From()
        from.flow = .unwind()

        to.show(from, sender: nil)
        XCTAssert(currentVc.didAppear())

        let output = 2018

        // Act
        from.produce(output)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == to)
        guard case .t1(let update)? = to.update else { XCTFail(); return }
        XCTAssert(update == output)
    }

    // MARK: Complex

    func testProduce_itWorksWithComplexFlow() {

        // Arrange
        class OutIntString: UIViewController, OutputProducing, UpdateHandling {
            typealias OutputType = OneOf2<Int, String>
            func handle(update: Float) { self.update = update }
            var update: Float!
        }
        class InIntOutDoubleString: UIViewController, IO {
            typealias InputType = Int
            typealias OutputType = OneOf2<Double, String>
        }
        class InDoubleOutFloat: UIViewController, IO {
            typealias InputType = Double
            typealias OutputType = Float
        }
        class InFloatOutFloat: UIViewController, IO {
            typealias InputType = Float
            typealias OutputType = Float
        }
        class InString: UIViewController, InputRequiring {
            typealias InputType = String
        }
        class InStringOutIntDoubleFloat: UIViewController, IO {
            typealias InputType = String
            typealias OutputType = OneOf3<Int, Double, Float>
        }

        let start = OutIntString().visible()
        start.flow = Flow(
            .show(InIntOutDoubleString.self,
                  .show(InDoubleOutFloat.self,
                        .show(InFloatOutFloat.self, .unwind())),
                  .show(InString.self)),
            .present(InStringOutIntDoubleFloat.self,
                     .present(InIntOutDoubleString.self,
                              .unwind(),
                              .present(InString.self)),
                     .present(InDoubleOutFloat.self,
                              .present(InFloatOutFloat.self, .unwind())),
                     .present(InFloatOutFloat.self)
            )
        )

        // Act
        start.produce("")
        XCTAssert(currentVc.didAppear())

        (currentVc as! InStringOutIntDoubleFloat).produce(0 as Double)
        XCTAssert(currentVc.didAppear())

        (currentVc as! InDoubleOutFloat).produce(0)
        XCTAssert(currentVc.didAppear())

        (currentVc as! InFloatOutFloat).produce(3.14)
        XCTAssert(currentVc.didDismiss())

        // Assert
        XCTAssert(currentVc == start)
        XCTAssert(start.update == 3.14)
    }
}
