import Foundation
import ObjectMapper

public enum ReachFiveError: Error {
    case RequestError(requestErrors: RequestErrors)
    case AuthFailure(reason: String)
    case AuthCanceled
    case TechnicalError(reason: String)
}

public class RequestErrors: NSObject, ImmutableMappable {
    public let error: String?
    public let errorId: String?
    public let errorUserMsg: String?
    public let errorDescription: String?
    public let errorDetails: [FieldError]?
    
    public required init(map: Map) throws {
        error = try? map.value("error")
        errorId = try? map.value("error_id")
        errorUserMsg = try? map.value("error_user_msg")
        errorDescription = try? map.value("error_description")
        errorDetails = try? map.value("error_details")
    }
    
    public func mapping(map: Map) {
        error >>> map["error"]
        errorId >>> map["error_id"]
        errorUserMsg >>> map["error_user_msg"]
        errorDescription >>> map["error_description"]
        errorDetails >>> map["error_details"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}

public class FieldError: NSObject, ImmutableMappable {
    public let field: String?
    public let message: String?
    public let code: String?
    
    public required init(map: Map) throws {
        field = try? map.value("field")
        message = try map.value("message")
        code = try? map.value("code")
    }
    
    public func mapping(map: Map) {
        field >>> map["field"]
        message >>> map["message"]
        code >>> map["code"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
