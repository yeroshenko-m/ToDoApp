//
//  AuthGetParams.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.02.2021.
//

import Foundation

struct AuthCodeRequestParams: Encodable {
    let clientId: String
    let scope: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case scope, state
        case clientId = "client_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(clientId, forKey: .clientId)
        try container.encode(scope, forKey: .scope)
        try container.encode(state, forKey: .state)
    }
}
