//
//  UIImage.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

extension UIImage {
    
    func add(image: UIImage, to size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        let resize = CGSize(width: self.size.width / scale, height:  self.size.height / scale)
        UIGraphicsBeginImageContext(resize)
        
        draw(in: CGRect(x: 0, y: 0, width: resize.width, height: resize.height))
        
        image.draw(in: CGRect(x: 24, y: resize.height - image.size.height * scale  - 24, width: image.size.width * scale, height: image.size.height * scale))
        
        let res = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return res ?? self
        
    }
    
    
    convenience init?(view: UIView) {
        view.layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
