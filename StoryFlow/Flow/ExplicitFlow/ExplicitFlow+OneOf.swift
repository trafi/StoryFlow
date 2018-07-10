import Foundation
import UIKit

// MARK: - Flow init

extension Flow where Value: _OneOf2Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>) {
        go = { from, value in
            guard let value = value as? OneOf2<Value.T1, Value.T2> else { return }
            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf3Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>) {
        go = { from, value in
            guard let value = value as? OneOf3<Value.T1, Value.T2, Value.T3> else { return }
            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf4Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>, _ f4: Flow<Value.T4>) {
        go = { from, value in
            guard let value = value as? OneOf4<Value.T1, Value.T2, Value.T3, Value.T4> else { return }
            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            case .t4(let v): f4.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf5Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>, _ f4: Flow<Value.T4>,
                _ f5: Flow<Value.T5>) {
        go = { from, value in
            guard let value = value as?
                OneOf5<Value.T1, Value.T2, Value.T3, Value.T4, Value.T5>
            else { return }

            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            case .t4(let v): f4.go(from, v)
            case .t5(let v): f5.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf6Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>, _ f4: Flow<Value.T4>,
                _ f5: Flow<Value.T5>, _ f6: Flow<Value.T6>) {
        go = { from, value in
            guard let value = value as?
                OneOf6<Value.T1, Value.T2, Value.T3, Value.T4, Value.T5, Value.T6>
            else { return }

            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            case .t4(let v): f4.go(from, v)
            case .t5(let v): f5.go(from, v)
            case .t6(let v): f6.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf7Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>, _ f4: Flow<Value.T4>,
                _ f5: Flow<Value.T5>, _ f6: Flow<Value.T6>, _ f7: Flow<Value.T7>) {
        go = { from, value in
            guard let value = value as?
                OneOf7<Value.T1, Value.T2, Value.T3, Value.T4, Value.T5, Value.T6, Value.T7>
            else { return }

            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            case .t4(let v): f4.go(from, v)
            case .t5(let v): f5.go(from, v)
            case .t6(let v): f6.go(from, v)
            case .t7(let v): f7.go(from, v)
            }
        }
    }
}

extension Flow where Value: _OneOf8Type {

    public init(_ f1: Flow<Value.T1>, _ f2: Flow<Value.T2>, _ f3: Flow<Value.T3>, _ f4: Flow<Value.T4>,
                _ f5: Flow<Value.T5>, _ f6: Flow<Value.T6>, _ f7: Flow<Value.T7>, _ f8: Flow<Value.T8>) {
        go = { from, value in
            guard let value = value as?
            OneOf8<Value.T1, Value.T2, Value.T3, Value.T4, Value.T5, Value.T6, Value.T7, Value.T8>
                else { return }

            switch value {
            case .t1(let v): f1.go(from, v)
            case .t2(let v): f2.go(from, v)
            case .t3(let v): f3.go(from, v)
            case .t4(let v): f4.go(from, v)
            case .t5(let v): f5.go(from, v)
            case .t6(let v): f6.go(from, v)
            case .t7(let v): f7.go(from, v)
            case .t8(let v): f8.go(from, v)
            }
        }
    }
}

// MARK: - Show IO Flow

extension Flow {

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf2Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf3Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf4Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3, f4))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf5Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3, f4, f5))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf6Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>, _ f7: Flow<C.OutputType.T7>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf7Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6, f7))
    }

    public static func show<C: UIViewController & IO>
        (_: C.Type,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>, _ f7: Flow<C.OutputType.T7>, _ f8: Flow<C.OutputType.T8>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf8Type {
            return Flow(.show(C.self), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6, f7, f8))
    }
}

// MARK: - Present IO Flow


extension Flow {

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf2Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf3Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf4Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3, f4))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf5Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3, f4, f5))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf6Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>, _ f7: Flow<C.OutputType.T7>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf7Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6, f7))
    }

    public static func present<C: UIViewController & IO>
        (_: C.Type, animated: Bool = true,
         _ f1: Flow<C.OutputType.T1>, _ f2: Flow<C.OutputType.T2>, _ f3: Flow<C.OutputType.T3>, _ f4: Flow<C.OutputType.T4>,
         _ f5: Flow<C.OutputType.T5>, _ f6: Flow<C.OutputType.T6>, _ f7: Flow<C.OutputType.T7>, _ f8: Flow<C.OutputType.T8>)
        -> Flow where Value == C.InputType, C.OutputType: _OneOf8Type {
            return Flow(.present(C.self, animated: animated), Flow<C.OutputType>(f1, f2, f3, f4, f5, f6, f7, f8))
    }
}
