import Foundation
import ObjectMapper

public class AuthCodeRequest: NSObject, ImmutableMappable {
    let clientId: String
    let code: String
    let grantType: String
    let redirectUri: String

    public convenience init(clientId: String, code: String) {
        self.init(clientId: clientId, code: code, grantType: "authorization_code", redirectUri: "reachfive://callback")
    }
    
    public init(clientId: String, code: String, grantType: String, redirectUri: String) {
        self.clientId = clientId
        self.code = code
        self.grantType = grantType
        self.redirectUri = redirectUri
    }
    
    public required init(map: Map) throws {
        clientId = try map.value("client_id")
        code = try map.value("code")
        grantType = try map.value("grant_type")
        redirectUri = try map.value("redirect_uri")
    }
    
    public func mapping(map: Map) {
        clientId >>> map["client_id"]
        code >>> map["code"]
        grantType >>> map["grant_type"]
        redirectUri >>> map["redirect_uri"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
