import Foundation

public class Address: Codable, DictionaryEncodable {
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
}
