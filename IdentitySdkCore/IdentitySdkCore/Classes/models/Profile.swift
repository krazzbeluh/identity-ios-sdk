import Foundation
import ObjectMapper

public class Profile: NSObject, ImmutableMappable {
    public let uid: String?
    public let signedUid: String?
    public let givenName: String?
    public let middleName: String?
    public let familyName: String?
    public let name: String?
    public let nickname: String?
    public let birthdate: String?
    public let profileURL: String?
    public let picture: String?
    public let externalId: String?
    public let authTypes: [String]?
    public let loginSummary: LoginSummary?
    public let username: String?
    public let gender: String?
    public let email: String?
    public let emailVerified: Bool?
    public let emails: Emails?
    public let phoneNumber: String?
    public let phoneNumberVerified: Bool?
    public let addresses: [Address]?
    public let locale: String?
    public let bio: String?
    public let customFields: [String: Any]?
    public let consents: [String: Consent]?
    public let tosAcceptedAt: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let company: String?
    public let liteOnly: Bool?

    public required init(
        uid: String? = nil,
        signedUid: String? = nil,
        givenName: String? = nil,
        middleName: String? = nil,
        familyName: String? = nil,
        name: String? = nil,
        nickname: String? = nil,
        birthdate: String? = nil,
        profileURL: String? = nil,
        picture: String? = nil,
        externalId: String? = nil,
        authTypes: [String]? = nil,
        loginSummary: LoginSummary? = nil,
        username: String? = nil,
        gender: String? = nil,
        email: String? = nil,
        emailVerified: Bool? = nil,
        emails: Emails? = nil,
        phoneNumber: String? = nil,
        phoneNumberVerified: Bool? = nil,
        addresses: [Address]? = nil,
        locale: String? = nil,
        bio: String? = nil,
        customFields: [String: Any]? = nil,
        consents: [String: Consent]? = nil,
        tosAcceptedAt: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        company: String? = nil,
        liteOnly: Bool? = nil
    ) {
        self.uid = uid
        self.signedUid = signedUid
        self.givenName = givenName
        self.middleName = middleName
        self.familyName = familyName
        self.name = name
        self.nickname = nickname
        self.birthdate = birthdate
        self.profileURL = profileURL
        self.picture = picture
        self.externalId = externalId
        self.authTypes = authTypes
        self.loginSummary = loginSummary
        self.username = username
        self.gender = gender
        self.email = email
        self.emailVerified = emailVerified
        self.emails = emails
        self.phoneNumber = phoneNumber
        self.phoneNumberVerified = phoneNumberVerified
        self.addresses = addresses
        self.locale = locale
        self.bio = bio
        self.customFields = customFields
        self.consents = consents
        self.tosAcceptedAt = tosAcceptedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.company = company
        self.liteOnly = liteOnly
    }

    public required init(map: Map) throws {
        uid = try? map.value("uid")
        signedUid = try? map.value("signed_uid")
        givenName = try? map.value("given_name")
        middleName = try? map.value("middle_name")
        familyName = try? map.value("family_name")
        name = try? map.value("name")
        nickname = try? map.value("nickname")
        birthdate = try? map.value("birthdate")
        profileURL = try? map.value("profile_url")
        picture = try? map.value("picture")
        externalId = try? map.value("external_id")
        authTypes = try? map.value("auth_types")
        loginSummary = try? map.value("login_summary")
        username = try? map.value("username")
        gender = try? map.value("gender")
        email = try? map.value("email")
        emailVerified = try? map.value("email_verified")
        emails = try? map.value("emails")
        phoneNumber = try? map.value("phone_number")
        phoneNumberVerified = try? map.value("phone_number_verified")
        addresses = try? map.value("addresses")
        locale = try? map.value("locale")
        bio = try? map.value("bio")
        customFields = try? map.value("custom_fields")
        consents = try? map.value("consents")
        tosAcceptedAt = try? map.value("tos_accepted_at")
        createdAt = try? map.value("created_at")
        updatedAt = try? map.value("updated_at")
        company = try? map.value("company")
        liteOnly = try? map.value("lite_only")
    }

    public func mapping(map: Map) {
        uid >>> map["uid"]
        signedUid >>> map["signed_uid"]
        givenName >>> map["given_name"]
        middleName >>> map["middle_name"]
        familyName >>> map["family_name"]
        name >>> map["name"]
        nickname >>> map["nickname"]
        birthdate >>> map["birthdate"]
        profileURL >>> map["profile_url"]
        picture >>> map["picture"]
        externalId >>> map["external_id"]
        authTypes >>> map["auth_types"]
        loginSummary >>> map["login_summary"]
        username >>> map["username"]
        gender >>> map["gender"]
        email >>> map["email"]
        emailVerified >>> map["email_verified"]
        emails >>> map["emails"]
        phoneNumber >>> map["phone_number"]
        phoneNumberVerified >>> map["phone_number_verified"]
        addresses >>> map["addresses"]
        locale >>> map["locale"]
        bio >>> map["bio"]
        customFields >>> map["custom_fields"]
        consents >>> map["consents"]
        tosAcceptedAt >>> map["tos_accepted_at"]
        createdAt >>> map["created_at"]
        updatedAt >>> map["updated_at"]
        company >>> map["company"]
        liteOnly >>> map["lite_only"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
