import Foundation
import ObjectMapper

public class ClientConfigResponse: NSObject, ImmutableMappable {
    public let scope: String
    
    public required init(map: Map) throws {
        scope = try map.value("scope")
    }
    
    public func mapping(map: Map) {
        scope >>> map["scope"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
