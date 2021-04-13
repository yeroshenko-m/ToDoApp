//
//  SystemHelper.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.04.2021.
//

import UIKit

final class SystemHelper {

	enum DeviceType {
		case iPad, iPhone, mac, undefined
	}

	static var isRunningOnMacCatalyst: Bool {
		#if targetEnvironment(macCatalyst)
		return true
		#else
		return false
		#endif
	}

	static var isRunningOnMobile: Bool {
		!isRunningOnMacCatalyst
	}

	static var currentDeviceType: DeviceType {
		let userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
		switch userInterfaceIdiom {
		case .phone:
			return .iPhone
		case _ where userInterfaceIdiom == .pad && isRunningOnMacCatalyst:
			return .mac
		case _ where userInterfaceIdiom == .pad && isRunningOnMobile:
			return .iPad
		default:
			return .undefined
		}
	}

}
