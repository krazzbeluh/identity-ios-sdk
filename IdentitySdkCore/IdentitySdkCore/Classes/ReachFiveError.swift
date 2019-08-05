import Foundation

public enum ReachFiveError: Error {
    case RequestError(requestErrors: RequestErrors)
    case AuthFailure(reason: String)
    case AuthCanceled
    case TechnicalError(reason: String)
}

public class RequestErrors: Codable {
    public let error: String?
    public let errorId: String?
    public let errorUserMsg: String?
    public let errorDescription: String?
    public let errorDetails: [FieldError]?
}

public class FieldError: Codable {
    public let field: String?
    public let message: String?
    public let code: String?
}
