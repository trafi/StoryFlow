import Foundation
import UIKit

extension UIViewController {

    func unwindVc(for updateType: Any.Type, filterOutSelf: Bool = true) -> UIViewController? {

        Thread.onMain {
            if canHandle(updateType, filterOutSelf: filterOutSelf) {
                return self
            } else if let vc = navBackStack?.first(where: { $0.canHandle(updateType) }) {
                return vc
            } else if let vc = otherTabs?.first(where: { $0.canHandle(updateType) }) {
                return vc
            } else {
                for nonVisibleVc in nonVisibleVcs {
                    guard let vc = nonVisibleVc.unwindVc(for: updateType, filterOutSelf: false) else { continue }
                    return vc
                }
                return nil
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

    func canHandle(_ updateType: Any.Type, filterOutSelf: Bool = false) -> Bool {
        return visibleVcs.contains { $0.isVc(for: updateType) && (filterOutSelf == false || $0 !== self) }
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

    var nonVisibleVcs: [UIViewController] {
        [presentingViewController, parent].compactMap { $0 }
            + (navBackStack ?? [])
            + (otherTabs ?? [])
    }

    var navBackStack: [UIViewController]? {
        guard let nav = navigationController ?? self as? UINavigationController else { return nil }
        return Array(nav.viewControllers.reversed().dropFirst())
    }

    var otherTabs: [UIViewController]? {
        guard let tab = tabBarController ?? self as? UITabBarController else { return nil }
        return tab.viewControllers?.filter { $0 !== tab.selectedViewController }
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
