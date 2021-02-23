//
//  R5PublicKeyCredentialParameter.swift
//  IdentitySdkCore
//
//  Created by admin on 11/01/2021.
//  Copyright © 2021 Reachfive. All rights reserved.
//

import Foundation

public class R5PublicKeyCredentialParameter: Codable, DictionaryEncodable {
    public var alg: Int
    public var type: String
    
    
    public init(alg: Int, type: String) {
        self.alg = alg
        self.type = type
       
    }
}
