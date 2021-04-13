//
//  TokenModelPostParams.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.02.2021.
//

import Foundation

struct AuthTokenRequestParams: Encodable {
    let clientId: String
    let clientSecret: String
    let code: String
    let redirectUrl: String
}
