import Foundation

public enum ReachFiveError: Error {
    case AuthFailure(reason: String)
    case AuthCanceled
    case TechnicalError(reason: String)
}
