//
//  CompletionTypealias.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

typealias VoidResultCompletion = (Result<Void, Error>) -> Void
typealias ResultCompletion<T> = (Result<T, Error>) -> Void
typealias AuthVoidResultCompletion = (Result<Void, AuthError>) -> Void
