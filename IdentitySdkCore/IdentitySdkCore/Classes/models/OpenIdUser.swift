import Foundation
import ObjectMapper

public class OpenIdUser: NSObject, ImmutableMappable {
    let id: String?
    let name: String?
    let preferredUsername: String?
    let givenName: String?
    let familyName: String?
    let middleName: String?
    let nickname: String?
    let picture: String?
    let website: String?
    let email: String?
    let emailVerified: Bool?
    let gender: String?
    let zoneinfo: String?
    let locale: String?
    let phoneNumber: String?
    let phoneNumberVerified: Bool?
    let address: ProfileAddress?
    
    public init(
        id: String?,
        name: String?,
        preferredUsername: String?,
        givenName: String?,
        familyName: String?,
        middleName: String?,
        nickname: String?,
        picture: String?,
        website: String?,
        email: String?,
        emailVerified: Bool?,
        gender: String?,
        zoneinfo: String?,
        locale: String?,
        phoneNumber: String?,
        phoneNumberVerified: Bool?,
        address: ProfileAddress?
    ) {
        self.id = id
        self.name = name
        self.preferredUsername = preferredUsername
        self.givenName = givenName
        self.familyName = familyName
        self.middleName = middleName
        self.nickname = nickname
        self.picture = picture
        self.website = website
        self.email = email
        self.emailVerified = emailVerified
        self.gender = gender
        self.zoneinfo = zoneinfo
        self.locale = locale
        self.phoneNumber = phoneNumber
        self.phoneNumberVerified = phoneNumberVerified
        self.address = address
    }
    
    public required init(map: Map) throws {
        id = try? map.value("id")
        name = try? map.value("name")
        preferredUsername = try? map.value("preferred_username")
        givenName = try? map.value("given_name")
        familyName = try? map.value("family_name")
        middleName = try? map.value("middle_name")
        nickname = try? map.value("nickname")
        picture = try? map.value("picture")
        website = try? map.value("website")
        email = try? map.value("email")
        emailVerified = try? map.value("email_verified")
        gender = try? map.value("gender")
        zoneinfo = try? map.value("zoneinfo")
        locale = try? map.value("locale")
        phoneNumber = try? map.value("phone_number")
        phoneNumberVerified = try? map.value("phone_number_verified")
        address = try? map.value("address")
    }
    
    public func mapping(map: Map) {
        id >>> map["id"]
        name >>> map["name"]
        preferredUsername >>> map["preferred_username"]
        givenName >>> map["given_name"]
        familyName >>> map["family_name"]
        middleName >>> map["middle_name"]
        nickname >>> map["nickname"]
        picture >>> map["picture"]
        website >>> map["website"]
        email >>> map["email"]
        emailVerified >>> map["email_verified"]
        gender >>> map["gender"]
        zoneinfo >>> map["zoneinfo"]
        locale >>> map["locale"]
        phoneNumber >>> map["phone_number"]
        phoneNumberVerified >>> map["phone_number_verified"]
        address >>> map["address"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}

