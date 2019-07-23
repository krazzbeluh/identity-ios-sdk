import Foundation

public extension ReachFive {
    func signupWithPassword(profile: ProfileRequest, scope: [String], callback: @escaping Callback<AuthToken, ReachFiveError>) {
        let signupRequest = SignupRequest(
            clientId: sdkConfig.clientId,
            data: profile,
            scope: scope.joined(separator: " "),
            acceptTos: nil
        )
        self.reachFiveApi.signupWithPassword(signupRequest: signupRequest, callback: handleAuthResponse(callback: callback))
    }
    
    func loginWithPassword(username: String, password: String, scope: [String], callback: @escaping Callback<AuthToken, ReachFiveError>) {
        let loginRequest = LoginRequest(
            username: username,
            password: password,
            grantType: "password",
            clientId: sdkConfig.clientId,
            scope: scope.joined(separator: " ")
        )
        self.reachFiveApi.loginWithPassword(loginRequest: loginRequest, callback: handleAuthResponse(callback: callback))
    }
}
