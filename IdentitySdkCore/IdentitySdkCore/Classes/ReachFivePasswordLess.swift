import Foundation
import BrightFutures

public enum PasswordLessRequest {
    case Email(email: String)
    case PhoneNumber(phoneNumber: String)
}

public extension ReachFive {
    func startPasswordless(_ request: PasswordLessRequest) -> Future<(), ReachFiveError> {
        switch request {
        case .Email(let email):
            let startPasswordlessRequest = StartPasswordlessRequest(
                clientId: sdkConfig.clientId,
                email: email,
                authType: .MagicLink
            )
            return reachFiveApi.startPasswordless(startPasswordlessRequest)
        case .PhoneNumber(let phoneNumber):
            let startPasswordlessRequest = StartPasswordlessRequest(
                clientId: sdkConfig.clientId,
                phoneNumber: phoneNumber,
                authType: .SMS
            )
            return reachFiveApi.startPasswordless(startPasswordlessRequest)
        }
    }
}
