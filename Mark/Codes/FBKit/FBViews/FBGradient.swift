//
//  FBGradient.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit

class FBGradient : FBView {
    
    let gradientLayer = CAGradientLayer()
    
    override func onSetup() {
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        gradientLayer.locations = [0,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        ob = observe(\.frame, changeHandler: { [weak self] _, _ in
            self?.fetch()
        })
    }
    
    
    override func layoutSubviews() {
        fetch()
    }
    
    override var frame: CGRect {
        didSet {
            fetch()
        }
    }
    
    func fetch() {
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    
    deinit {
        ob = nil
    }
    
    var ob: NSObjectProtocol?

}


