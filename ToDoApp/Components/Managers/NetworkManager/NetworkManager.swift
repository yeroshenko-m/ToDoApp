//
//  APIManager.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.02.2021.
//

import Alamofire

final class NetworkManager {

	// MARK: - Shared instance

	static let shared = NetworkManager()

	// MARK: - Private init

	private init() {}
	
	// MARK: - Methods
	
	func call<P: Encodable>(type: EndPointTypeProtocol,
							params: P,
							completion: @escaping VoidResultCompletion) {
		AF.request(type.url,
				   method: .post,
				   parameters: params,
				   encoder: JSONParameterEncoder.default,
				   headers: type.headers,
				   requestModifier: requestModifier)
			.validate()
			.responseData(queue: .main) { dataResponse in
				switch dataResponse.result {
				case .success:
					completion(.success(()) )
				case .failure(let error):
					completion(.failure(error))
				}
			}
	}
	
	func call(type: EndPointTypeProtocol,
			  completion: @escaping VoidResultCompletion) {
		AF.request(type.url,
				   method: type.httpMethod,
				   headers: type.headers,
				   requestModifier: requestModifier)
			.validate()
			.responseData(queue: .main) { dataResponse in
				switch dataResponse.result {
				case .success:
					completion(.success(()) )
				case .failure(let error):
					completion(.failure(error))
				}
			}
	}
	
	func call<T: Codable, P: Encodable>(type: EndPointTypeProtocol,
										params: P,
										completion: @escaping ResultCompletion<T>) {
		AF.request(type.url,
				   method: type.httpMethod,
				   parameters: params,
				   encoder: JSONParameterEncoder.default,
				   headers: type.headers,
				   requestModifier: requestModifier)
			.validate()
			.responseJSON { data in
				self.handleDataResponse(data, completion: completion)
			}
	}
	
	func call<T: Codable>(type: EndPointTypeProtocol,
						  completion: @escaping ResultCompletion<T>) {
		AF.request(type.url,
				   method: type.httpMethod,
				   headers: type.headers,
				   requestModifier: requestModifier)
			.validate()
			.responseJSON { data in
				self.handleDataResponse(data, completion: completion)
			}
	}
	
	// MARK: - Private implementation
	
	private func handleDataResponse<T: Codable>(_ data: AFDataResponse<Any>,
												completion: @escaping ResultCompletion<T>) {
		switch data.result {
		case .success:
			if let jsonData = data.data,
			   let result = try? JSONDecoder().decode(T.self, from: jsonData) {
				completion(.success(result))
			}
		case .failure:
			completion(.failure(data.error ?? NetworkError.noErrorData))
		}
	}

	private func requestModifier(request: inout URLRequest) {
		request.cachePolicy = .reloadIgnoringCacheData
	}
	
}

enum NetworkError: LocalizedError {
	case noErrorData
}
