//
//  Color.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import UIKit

struct TodoistColor {

    struct Color {
        let value: UIColor
        let id: Int
    }

    static func getColorBy(id: Int) -> UIColor {
        switch id {
        case _ where id == 30: return bordo.value
        case _ where id == 31: return red.value
        case _ where id == 32: return orange.value
        case _ where id == 33: return yellow.value
        case _ where id == 34: return khaki.value
        case _ where id == 35: return lightGreen.value
        case _ where id == 36: return darkGreen.value
        case _ where id == 37: return turquoise.value
        case _ where id == 38: return darkBlue.value
        case _ where id == 39: return blue.value
        case _ where id == 40: return lightBlue.value
        case _ where id == 41: return lightViolet.value
        case _ where id == 42: return violet.value
        case _ where id == 43: return darkPink.value
        case _ where id == 44: return lightPink.value
        case _ where id == 45: return pink.value
        case _ where id == 46: return peach.value
        case _ where id == 47: return darkGray.value
        case _ where id == 48: return lightGray.value
        case _ where id == 49: return powder.value

        default: return darkGray.value
        }
    }

    static let allColors = [ bordo, red, orange, yellow, khaki, lightGreen,
							 darkGreen, turquoise, darkBlue, blue, lightBlue,
							 lightViolet, violet, darkPink, lightPink, pink,
							 peach, darkGray, lightGray, powder]

    static let bordo = Color(value: UIColor(hex: "#b8255f") ?? .black, id: 30)
    static let red = Color(value: UIColor(hex: "#db4035") ?? .black, id: 31)
    static let orange = Color(value: UIColor(hex: "#ff9933") ?? .black, id: 32)
    static let yellow = Color(value: UIColor(hex: "#fad000") ?? .black, id: 33)
    static let khaki = Color(value: UIColor(hex: "#afb83b") ?? .black, id: 34)
    static let lightGreen = Color(value: UIColor(hex: "#7ecc49") ?? .black, id: 35)
    static let darkGreen = Color(value: UIColor(hex: "#299438") ?? .black, id: 36)
    static let turquoise = Color(value: UIColor(hex: "#6accbc") ?? .black, id: 37)
    static let darkBlue = Color(value: UIColor(hex: "#158fad") ?? .black, id: 38)
    static let blue = Color(value: UIColor(hex: "#14aaf5") ?? .black, id: 39)
    static let lightBlue = Color(value: UIColor(hex: "#96c3eb") ?? .black, id: 40)
    static let lightViolet = Color(value: UIColor(hex: "#4073ff") ?? .black, id: 41)
    static let violet = Color(value: UIColor(hex: "#884dff") ?? .black, id: 42)
    static let darkPink = Color(value: UIColor(hex: "#af38eb") ?? .black, id: 43)
    static let lightPink = Color(value: UIColor(hex: "#eb96eb") ?? .black, id: 44)
    static let pink = Color(value: UIColor(hex: "#e05194") ?? .black, id: 45)
    static let peach = Color(value: UIColor(hex: "#ff8d85") ?? .black, id: 46)
    static let darkGray = Color(value: UIColor(hex: "#808080") ?? .black, id: 47)
    static let lightGray = Color(value: UIColor(hex: "#b8b8b8") ?? .black, id: 48)
    static let powder = Color(value: UIColor(hex: "#ccac93") ?? .black, id: 49)
    
    static var defaultColor: Color { return darkGray }
	
}
