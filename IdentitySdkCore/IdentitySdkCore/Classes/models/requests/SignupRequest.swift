import Foundation
import ObjectMapper

public class SignupRequest: NSObject, ImmutableMappable {
    public let clientId: String
    public let data: Profile
    public let scope: String
    public let acceptTos: Bool?
    
    public init(clientId: String, data: Profile, scope: String, acceptTos: Bool?) {
        self.clientId = clientId
        self.data = data
        self.scope = scope
        self.acceptTos = acceptTos
    }

    public required init(map: Map) throws {
        clientId = try map.value("client_id")
        data = try map.value("data")
        scope = try map.value("scope")
        acceptTos = try? map.value("accep_tos")
    }

    public func mapping(map: Map) {
        clientId >>> map["client_id"]
        data >>> map["data"]
        scope >>> map["scope"]
        acceptTos >>> map["accept_tos"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
