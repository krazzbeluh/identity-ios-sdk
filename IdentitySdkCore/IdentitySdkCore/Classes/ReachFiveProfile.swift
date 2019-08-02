import Foundation

public extension ReachFive {
    func getProfile(authToken: AuthToken, callback: @escaping Callback<Profile, ReachFiveError>) {
        reachFiveApi.getProfile(authToken: authToken, callback: callback)
    }
    
    func verifyPhoneNumber(
        authToken: AuthToken,
        phoneNumber: String,
        verificationCode: String,
        callback: @escaping Callback<Void, ReachFiveError>
    ) {
        let verifyPhoneNumberRequest = VerifyPhoneNumberRequest(phoneNumber: phoneNumber, verificationCode: verificationCode)
        reachFiveApi
            .verifyPhoneNumber(
                authToken: authToken,
                verifyPhoneNumberRequest: verifyPhoneNumberRequest,
                callback: callback
        )
    }
    
    func updateEmail(
        authToken: AuthToken,
        email: String,
        redirectUrl: String? = nil,
        callback: @escaping Callback<Profile, ReachFiveError>
    ) {
        let updateEmailRequest = UpdateEmailRequest(email: email, redirectUrl: redirectUrl)
        reachFiveApi
            .updateEmail(
                authToken: authToken,
                updateEmailRequest: updateEmailRequest,
                callback: callback
        )
    }
    
    func updateProfile(
        authToken: AuthToken,
        profile: Profile,
        callback: @escaping Callback<Profile, ReachFiveError>
    ) {
        reachFiveApi.updateProfile(authToken: authToken, profile: profile, callback: callback)
    }
    
    func updatePassword(
        authToken: AuthToken,
        updatePasswordRequest: UpdatePasswordRequest,
        callback: @escaping Callback<Void, ReachFiveError>
    ) {
        reachFiveApi.updatePassword(authToken: authToken, updatePasswordRequest: updatePasswordRequest, callback: callback)
    }
    
    func requestPasswordReset(
        email: String?,
        phoneNumber: String?,
        redirectUrl: String? = nil,
        callback: @escaping Callback<Void, ReachFiveError>
    ) {
        let requestPasswordResetRequest = RequestPasswordResetRequest(
            clientId: sdkConfig.clientId, email: email, phoneNumber: phoneNumber, redirectUrl: redirectUrl
        )
        reachFiveApi
            .requestPasswordReset(
                requestPasswordResetRequest: requestPasswordResetRequest,
                callback: callback
        )
    }
    
    internal func handleAuthResponse(callback: @escaping Callback<AuthToken, ReachFiveError>) -> Callback<AccessTokenResponse, ReachFiveError> {
        return { response in
            callback(response.flatMap { openIdTokenResponse in
                AuthToken.fromOpenIdTokenResponse(openIdTokenResponse: openIdTokenResponse)
            })
        }
    }
}
