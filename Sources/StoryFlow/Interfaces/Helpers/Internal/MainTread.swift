import Foundation

extension Thread {

    static func onMain(_ work: @escaping () -> ()) {

        guard !Thread.isMainThread else { work(); return }

        let thread = DispatchGroup()
        thread.enter()

        DispatchQueue.main.async {
            work()
            thread.leave()
        }
        thread.wait()
    }
}
