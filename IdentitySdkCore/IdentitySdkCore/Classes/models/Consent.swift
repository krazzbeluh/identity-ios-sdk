import Foundation
import ObjectMapper

public class Consent: NSObject, ImmutableMappable {
    public let granted: Bool
    public let consentType: String?
    public let date: String
    
    public init(
        granted: Bool,
        consentType: String?,
        date: String
        ) {
        self.granted = granted
        self.consentType = consentType
        self.date = date
    }
    
    public required init(map: Map) throws {
        granted = try map.value("granted")
        consentType = try? map.value("consent_type")
        date = try map.value("date")
    }
    
    public func mapping(map: Map) {
        granted >>> map["granted"]
        consentType >>> map["consent_type"]
        date >>> map["date"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
