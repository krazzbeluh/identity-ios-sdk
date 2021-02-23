//
//  File.swift
//  IdentitySdkCore
//
//  Created by admin on 02/02/2021.
//


import Foundation

public class AuthenticationOptions: Codable, DictionaryEncodable {
    public let publicKey: R5PublicKeyCredentialRequestOptions
   
    
    public init(publicKey: R5PublicKeyCredentialRequestOptions) {
        self.publicKey = publicKey
    }
    
}
