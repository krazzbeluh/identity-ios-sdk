import Foundation
import ObjectMapper

public class LoginRequest: NSObject, ImmutableMappable {    
    let username: String
    let password: String
    let grantType: String
    let clientId: String
    let scope: String

    public init(username: String, password: String, grantType: String, clientId: String, scope: String) {
        self.username = username
        self.password = password
        self.grantType = grantType
        self.clientId = clientId
        self.scope = scope
    }

    public required init(map: Map) throws {
        username = try map.value("username")
        password = try map.value("password")
        grantType = try map.value("grant_type")
        clientId = try map.value("client_id")
        scope = try map.value("scope")
    }

    public func mapping(map: Map) {
        username >>> map["username"]
        password >>> map["password"]
        grantType >>> map["grant_type"]
        clientId >>> map["client_id"]
        scope >>> map["scope"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
