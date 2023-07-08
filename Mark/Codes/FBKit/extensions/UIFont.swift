//
//  UIFont.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit


//MARK: - UIFont
public extension UIFont {
    
    typealias FontSize = CGFloat
    
    static func regular(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    static func bold(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func normal(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    static func medium(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    static func semibold(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func heavy(_ size:FontSize) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)
    }
    
    static func din(_ size:FontSize) -> UIFont {
        return UIFont(name: "DIN Alternate Bold", size: size)!
    }
}

