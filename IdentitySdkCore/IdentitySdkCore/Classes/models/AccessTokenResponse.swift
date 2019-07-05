import Foundation
import ObjectMapper

public class AccessTokenResponse: NSObject, ImmutableMappable {
    let idToken: String?
    let accessToken: String
    let code: String?
    let tokenType: String?
    let expiresIn: Int?
    let error: String?
    let errorDescription: String?
    
    public init(idToken: String?, accessToken: String, code: String?, tokenType: String?, expiresIn: Int?, error: String?, errorDescription: String?) {
        self.idToken = idToken
        self.accessToken = accessToken
        self.code = code
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.error = error
        self.errorDescription = errorDescription
    }

    public required init(map: Map) throws {
        idToken = try? map.value("id_token")
        accessToken = try map.value("access_token")
        code = try? map.value("code")
        tokenType = try? map.value("token_type")
        expiresIn = try? map.value("expires_in")
        error = try? map.value("error")
        errorDescription = try? map.value("error_description")
    }

    public func mapping(map: Map) {
        idToken >>> map["id_token"]
        accessToken >>> map["access_token"]
        code >>> map["code"]
        tokenType >>> map["token_type"]
        expiresIn >>> map["expires_in"]
        error >>> map["error"]
        errorDescription >>> map["error_description"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
