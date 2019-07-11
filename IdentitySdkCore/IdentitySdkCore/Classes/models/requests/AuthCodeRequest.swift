import Foundation
import ObjectMapper

public class AuthCodeRequest: NSObject, ImmutableMappable {
    public let clientId: String
    public let code: String
    public let grantType: String
    public let redirectUri: String
    public let codeVerifier: String

    public convenience init(clientId: String, code: String, pkce: Pkce) {
        self.init(clientId: clientId, code: code, grantType: "authorization_code", redirectUri: "reachfive://callback", codeVerifier: pkce.codeVerifier)
    }
    
    public init(clientId: String, code: String, grantType: String, redirectUri: String, codeVerifier: String) {
        self.clientId = clientId
        self.code = code
        self.grantType = grantType
        self.redirectUri = redirectUri
        self.codeVerifier = codeVerifier
    }
    
    public required init(map: Map) throws {
        clientId = try map.value("client_id")
        code = try map.value("code")
        grantType = try map.value("grant_type")
        redirectUri = try map.value("redirect_uri")
        codeVerifier = try map.value("code_verifier")
    }
    
    public func mapping(map: Map) {
        clientId >>> map["client_id"]
        code >>> map["code"]
        grantType >>> map["grant_type"]
        redirectUri >>> map["redirect_uri"]
        codeVerifier >>> map["code_verifier"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
