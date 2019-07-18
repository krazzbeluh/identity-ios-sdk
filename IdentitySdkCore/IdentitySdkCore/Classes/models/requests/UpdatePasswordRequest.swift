import Foundation
import ObjectMapper

public class UpdatePasswordRequest: NSObject, ImmutableMappable {
    let clientId: String?
    let password: String?
    let oldPassword: String?
    let email: String?
    let phoneNumber: String?
    let verificationCode: String?
    
    public init(
        clientId: String?,
        password: String?,
        oldPassword: String?,
        email: String?,
        phoneNumber: String?,
        verificationCode: String?
    ) {
        self.clientId = clientId
        self.password = password
        self.oldPassword = oldPassword
        self.email = email
        self.phoneNumber = phoneNumber
        self.verificationCode = verificationCode
    }
    
    public required init(map: Map) throws {
        clientId = try? map.value("client_id")
        password = try? map.value("password")
        oldPassword = try? map.value("old_password")
        email = try? map.value("email")
        phoneNumber = try? map.value("phone_number")
        verificationCode = try? map.value("verification_code")
    }
    
    public func mapping(map: Map) {
        clientId >>> map["client_id"]
        password >>> map["password"]
        oldPassword >>> map["old_password"]
        email >>> map["email"]
        phoneNumber >>> map["phone_number"]
        verificationCode >>> map["verification_code"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
