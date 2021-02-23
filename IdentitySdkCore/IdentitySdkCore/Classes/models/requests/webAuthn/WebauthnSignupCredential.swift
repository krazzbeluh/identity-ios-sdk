//
//  WebauthnSignupCredential.swift
//  Alamofire
//
//  Created by admin on 01/02/2021.
//

import Foundation

public class WebauthnSignupCredential: Codable,DictionaryEncodable {
    public var webauthnId: String
    public var publicKeyCredential: RegistrationPublicKeyCredential
   
    
    public init(webauthnId: String, publicKeyCredential: RegistrationPublicKeyCredential) {
        self.webauthnId = webauthnId
        self.publicKeyCredential = publicKeyCredential
    }
    
   
}

