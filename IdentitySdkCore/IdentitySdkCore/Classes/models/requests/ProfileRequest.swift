import Foundation
import ObjectMapper

public class ProfileRequest: NSObject, ImmutableMappable {
    public let password: String
    public let email: String?
    public let phoneNumber: String?
    public let givenName: String?
    public let middleName: String?
    public let familyName: String?
    public let name: String?
    public let nickname: String?
    public let birthdate: String?
    public let profileURL: String?
    public let picture: String?
    public let username: String?
    public let gender: String?
    public let addresses: [Address]?
    public let locale: String?
    public let bio: String?
    public let customFields: [String: Any]?
    public let consents: [String: Consent]?
    public let tosAcceptedAt: String?
    public let liteOnly: Bool?
    
    public required init(
        password: String,
        email: String? = nil,
        phoneNumber: String? = nil,
        givenName: String? = nil,
        middleName: String? = nil,
        familyName: String? = nil,
        name: String? = nil,
        nickname: String? = nil,
        birthdate: String? = nil,
        profileURL: String? = nil,
        picture: String? = nil,
        username: String? = nil,
        gender: String? = nil,
        addresses: [Address]? = nil,
        locale: String? = nil,
        bio: String? = nil,
        customFields: [String: Any]? = nil,
        consents: [String: Consent]? = nil,
        tosAcceptedAt: String? = nil,
        liteOnly: Bool? = nil
    ) {
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.name = name
        self.nickname = nickname
        self.birthdate = birthdate
        self.profileURL = profileURL
        self.picture = picture
        self.username = username
        self.gender = gender
        self.addresses = addresses
        self.locale = locale
        self.bio = bio
        self.customFields = customFields
        self.consents = consents
        self.tosAcceptedAt = tosAcceptedAt
        self.liteOnly = liteOnly
    }
    
    public required init(map: Map) throws {
        password = try map.value("password")
        givenName = try? map.value("given_name")
        middleName = try? map.value("middle_name")
        familyName = try? map.value("family_name")
        name = try? map.value("name")
        nickname = try? map.value("nickname")
        birthdate = try? map.value("birthdate")
        profileURL = try? map.value("profile_url")
        picture = try? map.value("picture")
        username = try? map.value("username")
        gender = try? map.value("gender")
        email = try? map.value("email")
        phoneNumber = try? map.value("phone_number")
        addresses = try? map.value("addresses")
        locale = try? map.value("locale")
        bio = try? map.value("bio")
        customFields = try? map.value("custom_fields")
        consents = try? map.value("consents")
        tosAcceptedAt = try? map.value("tos_accepted_at")
        liteOnly = try? map.value("lite_only")
    }
    
    public func mapping(map: Map) {
        password >>> map["password"]
        email >>> map["email"]
        phoneNumber >>> map["phone_number"]
        givenName >>> map["given_name"]
        middleName >>> map["middle_name"]
        familyName >>> map["family_name"]
        name >>> map["name"]
        nickname >>> map["nickname"]
        birthdate >>> map["birthdate"]
        profileURL >>> map["profile_url"]
        picture >>> map["picture"]
        username >>> map["username"]
        gender >>> map["gender"]
        addresses >>> map["addresses"]
        locale >>> map["locale"]
        bio >>> map["bio"]
        customFields >>> map["custom_fields"]
        consents >>> map["consents"]
        tosAcceptedAt >>> map["tos_accepted_at"]
        liteOnly >>> map["lite_only"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
