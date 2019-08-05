import Foundation

public class SignupRequest: Codable, DictionaryEncodable {
    public let clientId: String
    public let data: ProfileSignupRequest
    public let scope: String
    public let acceptTos: Bool?
    
    public init(clientId: String, data: ProfileSignupRequest, scope: String, acceptTos: Bool?) {
        self.clientId = clientId
        self.data = data
        self.scope = scope
        self.acceptTos = acceptTos
    }
}
