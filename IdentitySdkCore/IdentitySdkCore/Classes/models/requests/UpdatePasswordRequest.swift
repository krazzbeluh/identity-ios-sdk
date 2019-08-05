import Foundation

public class UpdatePasswordRequest: Codable, DictionaryEncodable {
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
}
