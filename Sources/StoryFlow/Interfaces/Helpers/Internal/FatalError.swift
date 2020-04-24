import Foundation

#if TESTING
func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

struct FatalErrorUtil {

    fileprivate static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

    private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> ()) {
        fatalErrorClosure = {
            closure($0, $1, $2)
            repeat { RunLoop.current.run() } while (true)
        }
    }

    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}
#endif
