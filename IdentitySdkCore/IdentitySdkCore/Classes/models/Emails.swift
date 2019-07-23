import Foundation
import ObjectMapper

public class Emails: NSObject, ImmutableMappable {
    public let verified: [String]?
    public let unverified: [String]?
    
    public init(verified: [String]?, unverified: [String]?) {
        self.verified = verified
        self.unverified = unverified
    }
    
    public required init(map: Map) throws {
        verified = try? map.value("verified")
        unverified = try? map.value("unverified")
    }
    
    public func mapping(map: Map) {
        verified >>> map["verified"]
        unverified >>> map["unverified"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
