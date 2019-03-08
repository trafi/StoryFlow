import Foundation

typealias ValueAndType = (value: Any, type: Any.Type)

public enum OutputTransform {

    // MARK: Registering

    public static func register<From, To>(_ transform: @escaping (From) -> To) {
        transforms.append {
            guard
                $0.type == From.self,
                let from = $0.value as? From
            else { return nil }

            return (transform(from), To.self)
        }
    }

    // MARK: Applying

    static var transforms = [(ValueAndType) -> ValueAndType?]()

    static func apply(_ output: ValueAndType) -> ValueAndType {

        let unwrapped = unwrapOneOfN(output)
        for transform in transforms {
            guard let transformed = transform(unwrapped) else { break }
            return unwrapOneOfN(transformed)
        }

        return unwrapped
    }

    private static let unwrapOneOfN: (ValueAndType) -> ValueAndType = {
        guard let oneOf = $0.value as? OneOfNType else { return $0 }
        return oneOf.valueAndType
    }
}
