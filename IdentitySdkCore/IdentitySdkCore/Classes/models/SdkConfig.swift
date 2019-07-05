import Foundation

public class SdkConfig {
    public let domain: String
    public let clientId: String
    
    public init(domain: String, clientId: String) {
        self.domain = domain
        self.clientId = clientId
    }
}
