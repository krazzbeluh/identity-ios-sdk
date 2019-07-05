import Foundation
import ObjectMapper

public class ProviderConfig: NSObject, ImmutableMappable {
    public let provider: String
    public let clientId: String
    public let clientSecret: String?
    public let scope: [String]

    public required init(map: Map) throws {
        provider = try map.value("provider")
        clientId = try map.value("clientId")
        clientSecret = try? map.value("clientSecret")
        scope = try map.value("scope")
    }

    public func mapping(map: Map) {
        provider >>> map["provider"]
        clientId >>> map["clientId"]
        clientSecret >>> map["clientSecret"]
        scope >>> map["scope"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
