import XCTest
@testable import StoryFlow

class TestabilityTests: XCTestCase {

    func testInputRequiringInit_itAssignsInput() {

        // Arrange
        class T {}
        class Vc: UIViewController, InputRequiring { typealias InputType = T }

        let input = T()

        // Act
        let vc = Vc(input: input)

        // Assert
        XCTAssert(vc.input === input)
    }

    func testOutputProducingInit_itStubsOutput() {

        // Arrange
        class T {}
        class Vc: UIViewController, OutputProducing { typealias OutputType = T }

        var producedOutput: T!
        let vc = Vc(produce: { producedOutput = $0 })

        let output = T()

        // Act
        vc.produce(output)


        // Assert
        XCTAssert(producedOutput === output)

    }

    func testIOInit_itAssignsInputAndStubsOutput() {

        // Arrange
        class T {}
        class Vc: UIViewController, IO { typealias InputType = T; typealias OutputType = T }

        let value = T()
        var producedOutput: T!

        // Act
        let vc = Vc(input: value, produce: { producedOutput = $0 })
        vc.produce(value)

        // Assert
        XCTAssert(vc.input === value)
        XCTAssert(producedOutput === value)
    }
}
