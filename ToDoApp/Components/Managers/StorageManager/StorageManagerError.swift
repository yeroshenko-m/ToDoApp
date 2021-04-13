//
//  StorageManagerError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.02.2021.
//

import Foundation

enum StorageManagerError: Error {
	case cantFetchStoredRecord
	case cantAsyncFetchStoredRecords
	case cantSaveToStorage
}
