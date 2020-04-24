import Foundation
import UIKit

extension NSObject {

    private struct Box { let value: Any }

    func associated<T>(with key: UnsafeRawPointer) -> T? {
        return (objc_getAssociatedObject(self, key) as? Box)?.value as? T
    }

    func associate(_ value: Any?, with key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, value.flatMap(Box.init), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
