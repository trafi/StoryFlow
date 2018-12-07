import XCTest
import UIKit

// MARK: - CurrentVc

private let window: UIWindow = {

    UIView.setAnimationsEnabled(false)

    let window = UIWindow()
    window.makeKeyAndVisible()

    return window
}()

var currentVc: UIViewController {

    func currentVc(from vc: UIViewController) -> UIViewController {
        return (vc as? UINavigationController)?.topViewController.flatMap(currentVc)
            ?? vc.presentedViewController.flatMap(currentVc)
            ?? vc
    }

    return currentVc(from: window.rootViewController!)
}

extension UIViewController {

    @discardableResult
    func visible() -> Self {
        window.rootViewController = self
        return self
    }

    func didAppear() -> Bool {
        return XCTWaiter().completed { self.isBeingPresented == false }
    }

    func didDismiss() -> Bool {
        return XCTWaiter().completed {
            return self.presentingViewController == nil
        }
    }
}

extension XCTWaiter {

    func completed(description: String = #function,
                   timeout: TimeInterval = 1,
                   interval: TimeInterval = 0.002,
                   condition: @escaping () -> Bool) -> Bool {

        let expectation = XCTestExpectation(description: description)

        let t = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            guard condition() else { return }
            expectation.fulfill()
        }

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
        t.invalidate()

        return result
    }
}

// MARK: - Protocol

protocol LinkType: Equatable {}
struct Link: LinkType {}

// MARK: - CustomTransition

extension CustomTransition {
    static func reset() {
        attempts = []
    }
}

// MARK: - FatalError

@testable import StoryFlow

extension XCTestCase {
    func XCTAssertFatalError(expectedMessage: String? = nil, _ testCase: @escaping @autoclosure () -> Any) {

        // Arrange
        let e = expectation(description: "Expecting `fatalError`")
        FatalErrorUtil.replaceFatalError { _, _, _ in e.fulfill() }

        // Act
        DispatchQueue.global(qos: .userInitiated).async { _ = testCase() }

        // Assert
        waitForExpectations(timeout: 0.1) { _ in
            // Clean up
            FatalErrorUtil.restoreFatalError()
        }

    }
}
