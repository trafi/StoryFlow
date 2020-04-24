import Foundation
import UIKit

public indirect enum OneOf2<T1, T2> {
    case t1(T1), t2(T2)
}

public indirect enum OneOf3<T1, T2, T3> {
    case t1(T1), t2(T2), t3(T3)
}

public indirect enum OneOf4<T1, T2, T3, T4> {
    case t1(T1), t2(T2), t3(T3), t4(T4)
}

public indirect enum OneOf5<T1, T2, T3, T4, T5> {
    case t1(T1), t2(T2), t3(T3), t4(T4), t5(T5)
}

public indirect enum OneOf6<T1, T2, T3, T4, T5, T6> {
    case t1(T1), t2(T2), t3(T3), t4(T4), t5(T5), t6(T6)
}

public indirect enum OneOf7<T1, T2, T3, T4, T5, T6, T7> {
    case t1(T1), t2(T2), t3(T3), t4(T4), t5(T5), t6(T6), t7(T7)
}

public indirect enum OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> {
    case t1(T1), t2(T2), t3(T3), t4(T4), t5(T5), t6(T6), t7(T7), t8(T8)
}

// MARK: - Equatable

extension OneOf2: Equatable
where T1: Equatable, T2: Equatable {}

extension OneOf3: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable {}

extension OneOf4: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable {}

extension OneOf5: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable,
      T5: Equatable {}

extension OneOf6: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable,
      T5: Equatable, T6: Equatable {}

extension OneOf7: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable,
      T5: Equatable, T6: Equatable, T7: Equatable {}

extension OneOf8: Equatable
where T1: Equatable, T2: Equatable, T3: Equatable, T4: Equatable,
      T5: Equatable, T6: Equatable, T7: Equatable, T8: Equatable {}

// MARK: - Protocols

public protocol _OneOf2Type {
    associatedtype T1; associatedtype T2
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
}
public protocol _OneOf3Type {
    associatedtype T1; associatedtype T2; associatedtype T3
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
}
public protocol _OneOf4Type {
    associatedtype T1; associatedtype T2; associatedtype T3; associatedtype T4
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
    static func value(_ v: T4) -> Self
}
public protocol _OneOf5Type {
    associatedtype T1; associatedtype T2; associatedtype T3; associatedtype T4
    associatedtype T5
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
    static func value(_ v: T4) -> Self
    static func value(_ v: T5) -> Self
}
public protocol _OneOf6Type {
    associatedtype T1; associatedtype T2; associatedtype T3; associatedtype T4
    associatedtype T5; associatedtype T6
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
    static func value(_ v: T4) -> Self
    static func value(_ v: T5) -> Self
    static func value(_ v: T6) -> Self
}
public protocol _OneOf7Type {
    associatedtype T1; associatedtype T2; associatedtype T3; associatedtype T4
    associatedtype T5; associatedtype T6; associatedtype T7
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
    static func value(_ v: T4) -> Self
    static func value(_ v: T5) -> Self
    static func value(_ v: T6) -> Self
    static func value(_ v: T7) -> Self
}
public protocol _OneOf8Type {
    associatedtype T1; associatedtype T2; associatedtype T3; associatedtype T4
    associatedtype T5; associatedtype T6; associatedtype T7; associatedtype T8
    static func value(_ v: T1) -> Self
    static func value(_ v: T2) -> Self
    static func value(_ v: T3) -> Self
    static func value(_ v: T4) -> Self
    static func value(_ v: T5) -> Self
    static func value(_ v: T6) -> Self
    static func value(_ v: T7) -> Self
    static func value(_ v: T8) -> Self
}

// MARK: - _OneOf_Type

extension OneOf2: _OneOf2Type {
    public typealias T1 = T1; public typealias T2 = T2
    public static func value(_ v: T1) -> OneOf2<T1, T2> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf2<T1, T2> { return .t2(v) }
}

extension OneOf3: _OneOf3Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3
    public static func value(_ v: T1) -> OneOf3<T1, T2, T3> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf3<T1, T2, T3> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf3<T1, T2, T3> { return .t3(v) }
}

extension OneOf4: _OneOf4Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3; public typealias T4 = T4
    public static func value(_ v: T1) -> OneOf4<T1, T2, T3, T4> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf4<T1, T2, T3, T4> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf4<T1, T2, T3, T4> { return .t3(v) }
    public static func value(_ v: T4) -> OneOf4<T1, T2, T3, T4> { return .t4(v) }
}

extension OneOf5: _OneOf5Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3; public typealias T4 = T4
    public typealias T5 = T5
    public static func value(_ v: T1) -> OneOf5<T1, T2, T3, T4, T5> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf5<T1, T2, T3, T4, T5> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf5<T1, T2, T3, T4, T5> { return .t3(v) }
    public static func value(_ v: T4) -> OneOf5<T1, T2, T3, T4, T5> { return .t4(v) }
    public static func value(_ v: T5) -> OneOf5<T1, T2, T3, T4, T5> { return .t5(v) }
}

extension OneOf6: _OneOf6Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3; public typealias T4 = T4
    public typealias T5 = T5; public typealias T6 = T6

    public static func value(_ v: T1) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t3(v) }
    public static func value(_ v: T4) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t4(v) }
    public static func value(_ v: T5) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t5(v) }
    public static func value(_ v: T6) -> OneOf6<T1, T2, T3, T4, T5, T6> { return .t6(v) }
}

extension OneOf7: _OneOf7Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3; public typealias T4 = T4
    public typealias T5 = T5; public typealias T6 = T6
    public typealias T7 = T7

    public static func value(_ v: T1) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t3(v) }
    public static func value(_ v: T4) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t4(v) }
    public static func value(_ v: T5) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t5(v) }
    public static func value(_ v: T6) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t6(v) }
    public static func value(_ v: T7) -> OneOf7<T1, T2, T3, T4, T5, T6, T7> { return .t7(v) }
}

extension OneOf8: _OneOf8Type {
    public typealias T1 = T1; public typealias T2 = T2
    public typealias T3 = T3; public typealias T4 = T4
    public typealias T5 = T5; public typealias T6 = T6
    public typealias T7 = T7; public typealias T8 = T8

    public static func value(_ v: T1) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t1(v) }
    public static func value(_ v: T2) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t2(v) }
    public static func value(_ v: T3) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t3(v) }
    public static func value(_ v: T4) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t4(v) }
    public static func value(_ v: T5) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t5(v) }
    public static func value(_ v: T6) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t6(v) }
    public static func value(_ v: T7) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t7(v) }
    public static func value(_ v: T8) -> OneOf8<T1, T2, T3, T4, T5, T6, T7, T8> { return .t8(v) }
}

// MARK: OutputProducing

extension OutputProducing where Self: UIViewController, OutputType: _OneOf2Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf3Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf4Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf5Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf6Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf7Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
    public func produce(_ output: OutputType.T7) { produce(.value(output)) }
}

extension OutputProducing where Self: UIViewController, OutputType: _OneOf8Type {
    public func produce(_ output: OutputType.T1) { produce(.value(output)) }
    public func produce(_ output: OutputType.T2) { produce(.value(output)) }
    public func produce(_ output: OutputType.T3) { produce(.value(output)) }
    public func produce(_ output: OutputType.T4) { produce(.value(output)) }
    public func produce(_ output: OutputType.T5) { produce(.value(output)) }
    public func produce(_ output: OutputType.T6) { produce(.value(output)) }
    public func produce(_ output: OutputType.T7) { produce(.value(output)) }
    public func produce(_ output: OutputType.T8) { produce(.value(output)) }
}
