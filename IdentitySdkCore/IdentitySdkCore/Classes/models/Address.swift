import Foundation
import ObjectMapper

public class Address: NSObject, ImmutableMappable {
    public let title: String?
    public let isDefault: Bool?
    public let addressType: String?
    public let streetAddress: String?
    public let locality: String?
    public let region: String?
    public let postalCode: String?
    public let country: String?
    public let raw: String?
    public let deliveryNote: String?
    public let recipient: String?
    public let company: String?
    public let phoneNumber: String?
    
    public init(
        title: String?,
        isDefault: Bool?,
        addressType: String?,
        streetAddress: String?,
        locality: String?,
        region: String?,
        postalCode: String?,
        country: String?,
        raw: String?,
        deliveryNote: String?,
        recipient: String?,
        company: String?,
        phoneNumber: String?
    ) {
        self.title = title
        self.isDefault = isDefault
        self.addressType = addressType
        self.streetAddress = streetAddress
        self.locality = locality
        self.region = region
        self.postalCode = postalCode
        self.country = country
        self.raw = raw
        self.deliveryNote = deliveryNote
        self.recipient = recipient
        self.company = company
        self.phoneNumber = phoneNumber
    }
    
    public required init(map: Map) throws {
        title = try? map.value("title")
        isDefault = try? map.value("default")
        addressType = try? map.value("address_type")
        streetAddress = try? map.value("street_address")
        locality = try? map.value("locality")
        region = try? map.value("region")
        postalCode = try? map.value("postal_code")
        country = try? map.value("country")
        raw = try? map.value("raw")
        deliveryNote = try? map.value("delivery_note")
        recipient = try? map.value("recipient")
        company = try? map.value("company")
        phoneNumber = try? map.value("phone_number")
    }
    
    public func mapping(map: Map) {
        title >>> map["title"]
        isDefault >>> map["default"]
        addressType >>> map["address_type"]
        streetAddress >>> map["street_address"]
        locality >>> map["locality"]
        region >>> map["region"]
        postalCode >>> map["postal_code"]
        country >>> map["country"]
        raw >>> map["raw"]
        deliveryNote >>> map["delivery_note"]
        recipient >>> map["recipient"]
        company >>> map["company"]
        phoneNumber >>> map["phone_number"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
