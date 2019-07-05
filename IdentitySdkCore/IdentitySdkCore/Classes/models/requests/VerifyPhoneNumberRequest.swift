import Foundation
import ObjectMapper

public class VerifyPhoneNumberRequest: NSObject, ImmutableMappable {
    let phoneNumber: String
    let verificationCode: String
    
    public init(phoneNumber: String, verificationCode: String) {
        self.phoneNumber = phoneNumber
        self.verificationCode = verificationCode
    }

    public required init(map: Map) throws {
        phoneNumber = try map.value("phone_number")
        verificationCode = try map.value("verification_code")
    }
    
    public func mapping(map: Map) {
        phoneNumber >>> map["phone_number"]
        verificationCode >>> map["verification_code"]
    }
    
    public override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
}
