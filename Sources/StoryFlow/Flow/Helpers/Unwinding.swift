import Foundation
import UIKit

extension UIViewController {

    func unwindVc(for updateType: Any.Type) -> UIViewController? {
        return unwindVc(for: updateType, from: self)
    }

    private func unwindVc(for updateType: Any.Type, from source: UIViewController) -> UIViewController? {

        return Thread.onMain {
            if canHandle(updateType, from: source) {
                return self
            } else if let vc = navStacks.first(where: { $0.canHandle(updateType, from: source) }) {
                return vc
            } else if let vc = tabs.first(where: { $0.canHandle(updateType, from: source) }) {
                return vc
            } else {
                return (parent ?? presentingViewController)?.unwindVc(for: updateType, from: source)
            }
        }
    }

    func handleUpdate(_ value: Any, _ type: Any.Type) {
        Thread.onMain {
            visibleVcs.forEach { $0.asVc(for: type)?._handleAny(update: value) }
        }
    }
}

private extension UIViewController {

    func canHandle(_ updateType: Any.Type, from source: UIViewController) -> Bool {
        return visibleVcs.contains { $0.isVc(for: updateType) && $0 !== source }
    }

    var visibleVcs: [UIViewController] {
        if let nav = self as? UINavigationController {
            guard let top = nav.topViewController else { return [self] }
            return [self] + top.visibleVcs
        } else if let tab = self as? UITabBarController {
            guard let selected = tab.selectedViewController else { return [self] }
            return [self] + selected.visibleVcs
        } else {
            return [self] + children.flatMap { $0.visibleVcs }
        }
    }

    func allChild<T>(_ t: T.Type) -> [T] {
        return [self as? T].compactMap { $0 } + children.flatMap { $0.allChild(t) }
    }

    var navStacks: [UIViewController] {
        return allChild(UINavigationController.self).flatMap { $0.viewControllers.reversed() }
    }

    var tabs: [UIViewController] {
        return allChild(UITabBarController.self).flatMap { $0.viewControllers ?? [] }
    }

    func isVc(for updateType: Any.Type) -> Bool {
        return asVc(for: updateType) != nil
    }

    typealias UpdateHandlingVc = UIViewController & _AnyUpdateHandling

    func asVc(for updateType: Any.Type) -> UpdateHandlingVc? {
        guard let vc = self as? UpdateHandlingVc else { return nil }

        let vcUpdateType = type(of: vc)._updateType
        guard vcUpdateType == updateType || oneOf(vcUpdateType, contains: updateType) else { return nil }

        return vc
    }
}
