//
//  EndPointType.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.02.2021.
//

import Alamofire

protocol EndPointTypeProtocol {
	var baseURL: String { get }
	var path: String { get }
	var httpMethod: HTTPMethod { get }
	var headers: HTTPHeaders? { get }
	var url: URL { get }
	var encoding: ParameterEncoding { get }
}
