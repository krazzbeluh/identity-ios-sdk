import Foundation
import ObjectMapper

public class RequestPasswordResetRequest: NSObject, ImmutableMappable {
    public let clientId: String
    public let email: String?
    public let phoneNumber: String?
    public let redirectUrl: String?

    public init(clientId: String, email: String?, phoneNumber: String?, redirectUrl: String?) {
        self.clientId = clientId
        self.email = email
        self.phoneNumber = phoneNumber
        self.redirectUrl = redirectUrl
    }

    public required init(map: Map) throws {
        clientId = try map.value("client_id")
        email = try? map.value("email")
        phoneNumber = try? map.value("phone_number")
        redirectUrl = try? map.value("redirect_url")
    }

    public func mapping(map: Map) {
        clientId >>> map["client_id"]
        email >>> map["email"]
        phoneNumber >>> map["phone_number"]
        redirectUrl >>> map["redirect_url"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
