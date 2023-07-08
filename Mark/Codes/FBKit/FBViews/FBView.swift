//
//  FBView.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import Foundation

class FBView : UIView {
    
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
        onSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func onInit() {
        
    }
    
    @objc dynamic func onSetup() {
        
    }
        
    //MARK: - Gradient
    lazy var gradient = FBGradient()
    func addGradient() {
        insertSubview(gradient, at: 0)
        gradient.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    convenience init(frame: CGRect, background color: UIColor, corner radius: CGFloat? = nil, superview: UIView? = nil) {
        self.init(frame: frame)
        self.backgroundColor = color
        if let radius {
            self.cornerRadius = radius
        }
        superview?.addSubview(self)
    }
    
    var onLayoutCallback: ((FBView) ->Void)?
    
    override var frame: CGRect {
        didSet {
            onLayoutCallback?(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        onLayoutCallback?(self)
    }
}
