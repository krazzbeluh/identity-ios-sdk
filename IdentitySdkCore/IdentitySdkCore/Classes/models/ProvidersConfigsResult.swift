import Foundation
import ObjectMapper

public class ProvidersConfigsResult: NSObject, ImmutableMappable {
    let items: [ProviderConfig]
    let status: String
    
    public required init(map: Map) throws {
        items = (try? map.value("items")) ?? []
        status = try map.value("status")
    }
    
    public func mapping(map: Map) {
        items >>> map["items"]
        status >>> map["status"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
