import Foundation

final class Logger {
    func d(_ message: String) {
        #if DEBUG
        print("# \(message)")
        #endif
    }

    func e(_ message: String) {
        #if DEBUG
        print("# ❌ \(message)")
        #endif
    }
}

let log = Logger()
