import Foundation
import BrightFutures

public extension ReachFive {
    func getProfile(authToken: AuthToken) -> Future<Profile, ReachFiveError> {
        return reachFiveApi.getProfile(authToken: authToken)
    }
    
    func verifyPhoneNumber(
        authToken: AuthToken,
        phoneNumber: String,
        verificationCode: String
    ) -> Future<Void, ReachFiveError> {
        let verifyPhoneNumberRequest = VerifyPhoneNumberRequest(
            phoneNumber: phoneNumber,
            verificationCode: verificationCode
        )
        return self.reachFiveApi
            .verifyPhoneNumber(authToken: authToken, verifyPhoneNumberRequest: verifyPhoneNumberRequest)
    }
    
    func updateEmail(
        authToken: AuthToken,
        email: String,
        redirectUrl: String? = nil
    ) -> Future<Profile, ReachFiveError> {
        let updateEmailRequest = UpdateEmailRequest(email: email, redirectUrl: redirectUrl)
        return reachFiveApi.updateEmail(
            authToken: authToken,
            updateEmailRequest: updateEmailRequest
        )
    }
    
    func updatePhoneNumber(
        authToken: AuthToken,
        phoneNumber: String
    ) -> Future<Profile, ReachFiveError> {
        let updatePhoneNumberRequest = UpdatePhoneNumberRequest(phoneNumber: phoneNumber)
        return reachFiveApi.updatePhoneNumber(
            authToken: authToken,
            updatePhoneNumberRequest: updatePhoneNumberRequest
        )
    }
    
    func updateProfile(
        authToken: AuthToken,
        profile: Profile
    ) -> Future<Profile, ReachFiveError> {
        return reachFiveApi.updateProfile(authToken: authToken, profile: profile)
    }
    
    func updatePassword(
        authToken: AuthToken,
        updatePasswordRequest: UpdatePasswordRequest
    ) -> Future<Void, ReachFiveError> {
        return reachFiveApi.updatePassword(
            authToken: authToken,
            updatePasswordRequest: updatePasswordRequest
        )
    }
    
    func requestPasswordReset(
        email: String?,
        phoneNumber: String?,
        redirectUrl: String? = nil
    ) -> Future<Void, ReachFiveError> {
        let requestPasswordResetRequest = RequestPasswordResetRequest(
            clientId: sdkConfig.clientId,
            email: email,
            phoneNumber: phoneNumber,
            redirectUrl: redirectUrl
        )
        return reachFiveApi.requestPasswordReset(
            requestPasswordResetRequest: requestPasswordResetRequest
        )
    }
}
