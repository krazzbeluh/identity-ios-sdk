import Foundation
import ObjectMapper

public class ProfileAddress: NSObject, ImmutableMappable {
    let formatted: String
    let streetAddress: String
    let locality: String
    let region: String
    let postalCode: String
    let country: String
    
    public init(
        formatted: String,
        streetAddress: String,
        locality: String,
        region: String,
        postalCode: String,
        country: String
    ) {
        self.formatted = formatted
        self.streetAddress = streetAddress
        self.locality = locality
        self.region = region
        self.postalCode = postalCode
        self.country = country
    }
    
    public required init(map: Map) throws {
        formatted = try map.value("formatted")
        streetAddress = try map.value("streetAddress")
        locality = try map.value("locality")
        region = try map.value("region")
        postalCode = try map.value("postalCode")
        country = try map.value("country")
    }
    
    public func mapping(map: Map) {
        formatted >>> map["formatted"]
        streetAddress >>> map["streetAddress"]
        locality >>> map["locality"]
        region >>> map["region"]
        postalCode >>> map["postalCode"]
        country >>> map["country"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
