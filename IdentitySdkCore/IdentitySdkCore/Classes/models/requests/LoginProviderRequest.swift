import Foundation
import ObjectMapper

public class LoginProviderRequest: NSObject, ImmutableMappable {
    let provider: String
    let providerToken: String?
    let code: String?
    let origin: String?
    let clientId: String
    let responseType: String
    let scope: String
    
    public init(provider: String, providerToken: String?, code: String?, origin: String?, clientId: String, responseType: String, scope: String) {
        self.provider = provider
        self.providerToken = providerToken
        self.code = code
        self.origin = origin
        self.clientId = clientId
        self.responseType = responseType
        self.scope = scope
    }
    
    public required init(map: Map) throws {
        provider = try map.value("provider")
        providerToken = try? map.value("provider_token")
        code = try? map.value("code")
        origin = try? map.value("origin")
        clientId = try map.value("client_id")
        responseType = try map.value("response_type")
        scope = try map.value("scope")
    }
    
    public func mapping(map: Map) {
        provider >>> map["provider"]
        providerToken >>> map["provider_token"]
        code >>> map["code"]
        origin >>> map["origin"]
        clientId >>> map["client_id"]
        responseType >>> map["response_type"]
        scope >>> map["scope"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
