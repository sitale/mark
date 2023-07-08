//
//  UIView.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit


extension UIImageView {
    @discardableResult
    convenience init(_ frame: CGRect, image: UIImage?, superview: UIView? = nil) {
        self.init(frame: frame)
        self.image = image
        self.contentMode = .scaleAspectFit
        superview?.addSubview(self)
    }
}


extension UILabel {
    @discardableResult
    convenience init(_ frame: CGRect,_ text: String,_ color: UIColor, font: UIFont, superview: UIView? = nil) {
        self.init(frame: frame)
        self.text = text
        self.textColor = color
        self.font = font
        superview?.addSubview(self)
    }
    

    func set(_ text: String, _ font: UIFont, color: UIColor, alignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.font = font
        self.textColor = color
        self.text = text
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        
    }
}


extension UIView {
    func addCorner(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.path = path.cgPath
        self.layer.mask = layer
    }
    
    func asImage() -> UIImage? {
          let renderer = UIGraphicsImageRenderer(bounds: bounds)
          let image =  renderer.image { rendererContext in
              layer.render(in: rendererContext.cgContext)
          }
        if image.ciImage == nil {
            fatalError("without cgimage")
        }
        return image
      }
    
    func generatePicture() -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.prefersExtendedRange = true
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        var image = renderer.image { (context)  in
            context.cgContext.concatenate(CGAffineTransform.identity.scaledBy(x: 1, y: 1))
            return self.layer.render(in: context.cgContext)
//            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        if image.ciImage == nil {
            fatalError("without cgimage")
        }
        
        return image
    }
    
    func snaphot() -> UIImage? {
        layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            layer.render(in: ctx)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    
    enum Position {
        case left
        case right
        case top
        case bottom
        case centerX
        case centerY
    }
    
    /// 给view添加线条
    
    @discardableResult
    func addLine( _ pos: Position, color: UIColor = .line, lineWidth: CGFloat = 0.5, offset: CGFloat = 0, margin: CGFloat  = 0,ileft:CGFloat = 0, tag: Int = 0) -> UIView {
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = color
        line.tag = tag
        switch pos {
        case .top,.bottom:
            line.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                if ileft != 0 {
                    make.left.equalTo(ileft)
                } else {
                    make.width.equalToSuperview().offset(margin)
                }
                make.height.equalTo(lineWidth)
                if pos == .top {
                    make.top.equalTo(offset)
                } else {
                    make.bottom.equalTo(offset)
                }
            }
        case .left, .right:
            line.snp.makeConstraints { make in
                if pos == .left {
                    make.left.equalTo(offset)
                } else {
                    make.right.equalTo(offset)
                }
                make.top.equalTo(margin)
                make.width.equalTo(lineWidth)
                make.bottom.equalTo(-margin)
            }
        case .centerX, .centerY:
            line.snp.makeConstraints { make in
                make.center.equalToSuperview()
                if pos == .centerX {
                    make.width.equalTo(lineWidth)
                    make.height.equalToSuperview().offset(offset)
                } else {
                    make.height.equalTo(lineWidth)
                    make.width.equalToSuperview().offset(offset)
                }
            }
        }
        
        return line
    }
}
