//
//  AuthenticationPublicKeyCredential.swift
//  IdentitySdkCore
//
//  Created by admin on 04/02/2021.
//

import Foundation

public class AuthenticationPublicKeyCredential: Codable, DictionaryEncodable {
    public var id: String
    public var rawId: String
    public var type: String
    public var response: R5AuthenticatorAssertionResponse

    public init(id: String, rawId: String, type: String, response: R5AuthenticatorAssertionResponse) {
        self.id = id
        self.rawId = rawId
        self.type = type
        self.response = response
    }
}
