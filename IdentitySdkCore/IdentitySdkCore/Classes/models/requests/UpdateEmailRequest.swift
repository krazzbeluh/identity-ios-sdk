import Foundation
import ObjectMapper

public class UpdateEmailRequest: NSObject, ImmutableMappable {
    let email: String
    let redirectUrl: String?

    public init(email: String, redirectUrl: String?) {
        self.email = email
        self.redirectUrl = redirectUrl
    }

    public required init(map: Map) throws {
        email = try map.value("email")
        redirectUrl = try? map.value("redirect_url")
    }

    public func mapping(map: Map) {
        email >>> map["email"]
        redirectUrl >>> map["redirect_url"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
