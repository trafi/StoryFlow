import Foundation
import UIKit

import OneOfUs

func oneOf(_ types: Any.Type, contains type: Any.Type) -> Bool {
    guard let oneOfType = types as? OneOfNType.Type else { return types == type }
    return oneOfType.unwrappedValueTypes.contains { $0 == type }
}

// MARK: - Protocol

protocol OneOfNType {
    var valueAndType: ValueAndType { get }
    static var valueTypes: [Any.Type] { get }
    static func create(from value: Any) -> Any?
}

extension OneOfNType {
    static var unwrappedValueTypes: [Any.Type] {
        return valueTypes.flatMap { ($0 as? OneOfNType.Type)?.unwrappedValueTypes ?? [$0] }
    }
    static func wrappedCreate(from value: Any) -> Any? {
        for valueType in valueTypes {
            if valueType == type(of: value) {
                return create(from: value)
            } else if let oneOfType = valueType as? OneOfNType.Type,
                      let nestedValue = oneOfType.wrappedCreate(from: value) {
                return create(from: nestedValue)
            }
        }
        return nil
    }
}

// MARK: - Conformance

extension OneOf2: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf2.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf2.t2(v)
        default: return nil
        }
    }
}

extension OneOf3: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf3.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf3.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf3.t3(v)
        default: return nil
        }
    }
}

extension OneOf4: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        case .t4(let v): return (v, T4.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self, T4.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf4.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf4.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf4.t3(v)
        case let v as T4 where type(of: v) == T4.self: return OneOf4.t4(v)
        default: return nil
        }
    }
}

extension OneOf5: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        case .t4(let v): return (v, T4.self)
        case .t5(let v): return (v, T5.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self, T4.self, T5.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf5.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf5.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf5.t3(v)
        case let v as T4 where type(of: v) == T4.self: return OneOf5.t4(v)
        case let v as T5 where type(of: v) == T5.self: return OneOf5.t5(v)
        default: return nil
        }
    }
}

extension OneOf6: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        case .t4(let v): return (v, T4.self)
        case .t5(let v): return (v, T5.self)
        case .t6(let v): return (v, T6.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf6.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf6.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf6.t3(v)
        case let v as T4 where type(of: v) == T4.self: return OneOf6.t4(v)
        case let v as T5 where type(of: v) == T5.self: return OneOf6.t5(v)
        case let v as T6 where type(of: v) == T6.self: return OneOf6.t6(v)
        default: return nil
        }
    }
}

extension OneOf7: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        case .t4(let v): return (v, T4.self)
        case .t5(let v): return (v, T5.self)
        case .t6(let v): return (v, T6.self)
        case .t7(let v): return (v, T7.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self, T7.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf7.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf7.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf7.t3(v)
        case let v as T4 where type(of: v) == T4.self: return OneOf7.t4(v)
        case let v as T5 where type(of: v) == T5.self: return OneOf7.t5(v)
        case let v as T6 where type(of: v) == T6.self: return OneOf7.t6(v)
        case let v as T7 where type(of: v) == T7.self: return OneOf7.t7(v)
        default: return nil
        }
    }
}

extension OneOf8: OneOfNType {
    var valueAndType: ValueAndType {
        switch self {
        case .t1(let v): return (v, T1.self)
        case .t2(let v): return (v, T2.self)
        case .t3(let v): return (v, T3.self)
        case .t4(let v): return (v, T4.self)
        case .t5(let v): return (v, T5.self)
        case .t6(let v): return (v, T6.self)
        case .t7(let v): return (v, T7.self)
        case .t8(let v): return (v, T8.self)
        }
    }
    static var valueTypes: [Any.Type] {
        return [T1.self, T2.self, T3.self, T4.self, T5.self, T6.self, T7.self, T8.self]
    }
    static func create(from value: Any) -> Any? {
        switch value {
        case let v as T1 where type(of: v) == T1.self: return OneOf8.t1(v)
        case let v as T2 where type(of: v) == T2.self: return OneOf8.t2(v)
        case let v as T3 where type(of: v) == T3.self: return OneOf8.t3(v)
        case let v as T4 where type(of: v) == T4.self: return OneOf8.t4(v)
        case let v as T5 where type(of: v) == T5.self: return OneOf8.t5(v)
        case let v as T6 where type(of: v) == T6.self: return OneOf8.t6(v)
        case let v as T7 where type(of: v) == T7.self: return OneOf8.t7(v)
        case let v as T8 where type(of: v) == T8.self: return OneOf8.t8(v)
        default: return nil
        }
    }
}
