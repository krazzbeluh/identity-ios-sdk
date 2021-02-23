import Foundation

public class WAKLogger {

    public static var available: Bool = false

    public static func debug(_ msg: String) {
        if available {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let dateString = formatter.string(from: Date())
            print("\(dateString) [RNWebAuthnKit]" + msg)
        }
    }
}
