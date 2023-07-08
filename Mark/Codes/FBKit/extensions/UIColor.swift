//
//  UIColor.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit

extension UIColor {
    /// hex值颜色构造方法
    convenience init(_ hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((((hex) >> 16) & 0x0000ff)) / 255.0, green: CGFloat((((hex) >> 8)) & 0x0000ff) / 255.0, blue: CGFloat(((hex) & 0x0000ff)) / 255.0, alpha: alpha)
    }
    
}

extension UIColor {
    static let line = UIColor(0xE0E0E0)
    static let bgColor = UIColor(0x000000)
    static let cellColor = UIColor(0x1A1E2C)
    
    static let title = UIColor(0x333333)
    static let detail = UIColor(0x666666)
    static let second = UIColor(0x999999)
    
    
    static let process = UIColor(0xE7E7E7)
    static let c97 = UIColor(0x979797)
    
    static let theme = UIColor(0x64CCE1)
    static let ce7 = UIColor(0xE7E7E7)
    
    static let selected = UIColor(0x3B8A6B)
    static let normal = UIColor(0xB6B6C8)
    
    static let cblue = UIColor(0x0E42FF)

}
