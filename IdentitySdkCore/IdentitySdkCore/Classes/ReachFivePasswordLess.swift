import Foundation
import BrightFutures

public enum PasswordLessRequest {
    case Email(email: String)
    case PhoneNumber(phoneNumber: String)
}

public extension ReachFive {
    
    func addPasswordlessCallback(passwordlessCallback: @escaping PasswordlessCallback) {
        self.passwordlessCallback = passwordlessCallback
    }
        
    func startPasswordless(_ request: PasswordLessRequest) -> Future<(), ReachFiveError> {
        let pkce = Pkce.generate()
        self.storage.save(key: "PASSWORDLESS_PKCE", value: pkce)
        switch request {
        case .Email(let email):
            let startPasswordlessRequest = StartPasswordlessRequest(
                clientId: sdkConfig.clientId,
                email: email,
                authType: .MagicLink,
                codeChallenge: pkce.codeChallenge,
                codeChallengeMethod: pkce.codeChallengeMethod
            )
            return reachFiveApi.startPasswordless(startPasswordlessRequest)
        case .PhoneNumber(let phoneNumber):
            let startPasswordlessRequest = StartPasswordlessRequest(
                clientId: sdkConfig.clientId,
                phoneNumber: phoneNumber,
                authType: .SMS,
                codeChallenge: pkce.codeChallenge,
                codeChallengeMethod: pkce.codeChallengeMethod
            )
            return reachFiveApi.startPasswordless(startPasswordlessRequest)
        }
    }
    
    func verifyPasswordlessCode(verifyAuthCodeRequest: VerifyAuthCodeRequest) -> Future<AuthToken, ReachFiveError> {
        let pkce: Pkce? = self.storage.take(key: "PASSWORDLESS_PKCE")
        return self.reachFiveApi
            .verifyAuthCode(verifyAuthCodeRequest: verifyAuthCodeRequest)
            .flatMap { _ -> Future<AuthToken, ReachFiveError> in
                let verifyPasswordlessRequest = VerifyPasswordlessRequest(
                    email: verifyAuthCodeRequest.email,
                    phoneNumber: verifyAuthCodeRequest.phoneNumber,
                    verificationCode: verifyAuthCodeRequest.verificationCode,
                    state: "passwordless",
                    redirectUri: ReachFive.REDIRECT_URI,
                    clientId: self.sdkConfig.clientId,
                    responseType: "code"
                )
                return self.reachFiveApi
                    .verifyPasswordless(verifyPasswordlessRequest: verifyPasswordlessRequest)
                    .flatMap { response -> Future<AuthToken, ReachFiveError> in
                        let authCodeRequest = AuthCodeRequest(clientId: self.sdkConfig.clientId, code: response.code ?? "", pkce: pkce!)
                        return self.reachFiveApi.authWithCode(authCodeRequest: authCodeRequest)
                            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
                    }
            }
    }
    
    internal func interceptPasswordless(_ url: URL) {
        let params = QueryString.parseQueriesStrings(query: url.query ?? "")
        let pkce: Pkce? = self.storage.take(key: "PASSWORDLESS_PKCE")
        if (pkce != nil) {
            if let state = params["state"] {
                if state == "passwordless" {
                    if let code = params["code"] {
                        let authCodeRequest = AuthCodeRequest(clientId: self.sdkConfig.clientId, code: code ?? "", pkce: pkce!)
                        
                        self.reachFiveApi.authWithCode(authCodeRequest: authCodeRequest)
                            .flatMap({ AuthToken.fromOpenIdTokenResponseFuture($0) })
                            .onComplete { result in
                                self.passwordlessCallback?(result)
                            }
                    }
                }
            }
        } else {
            self.passwordlessCallback?(.failure(.TechnicalError(reason: "Pkce not found")))
        }
    }
}
