//
//  AuthenticationToken.swift
//  IdentitySdkCore
//
//  Created by admin on 01/02/2021.
//

import Foundation

public class AuthenticationToken: Codable, DictionaryEncodable {
    public let tkn: String
   
    
    public init(tkn: String) {
        self.tkn = tkn
    }
    
}
