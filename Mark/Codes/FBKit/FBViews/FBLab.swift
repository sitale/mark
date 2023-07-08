//
//  FBImageLab.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit
import SnapKit
import SwifterSwift


class FBTile : FBLab {
    let arrow   = FBLab()
    let backgroundImageView = UIImageView()
    let detailLab = FBLab()
    
    override func onSetup() {
        super.onSetup()
        addSubviews([backgroundImageView, arrow, detailLab])
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    enum TileStyle {
        /*
                title
         icon
                detail
         */
        case style1
        
        /*
         icon  title               arrow
         */
        case style2
        /*
         icon title                 detail arrow
         */
        case style3
    }
    
    var leadingStyle: Style     = .imgLab(leading: 15, size: 36, spacing: 10, trailling: 0)
    { didSet {
        updateStyleLayout()
    }}
    var trailingStyle: Style    = .labImg(leading: 0, size: 10, spacing: 4, trailling: 15)
    { didSet {
        updateStyleLayout()
    }}
    
    func updateStyleLayout() {
        fetch(leadingStyle)
        arrow.fetch(trailingStyle)
        arrow.snp.remakeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    
    
}

class FBLab : FBView {
    typealias FBLabCallback = ((FBLab) -> Void)
    
    let icon    = UIImageView()
    let lab     = UILabel()

    var imageView: UIImageView { icon }
    var titleLabel: UILabel { lab }
    
    
    
    enum State {
        case normal, selected, disabled
    }
    
    var onSelected: FBLabCallback?
    var onEnabled: FBLabCallback?
    var onDisabled: FBLabCallback?
    
    
    var isSelected: Bool {
        get { state == .selected }
        set {
            state = newValue ? .selected : .normal
            onStateDidChaned()
        }
    }
    
    var isEnabled: Bool {
        set {
            state = newValue ? .normal : .disabled
            onStateDidChaned()
        }
        get { state != .disabled }
    }
    
    var state: State = .normal {
        didSet {
            switch state {
            case .normal:
                onEnabled?(self)
            case .selected:
                onSelected?(self)
            case .disabled:
                onDisabled?(self)
            }
            onStateDidChaned()
        }
    }
    
    
    
    
    var fonts           = Dictionary<State,UIFont>()
    var texts           = Dictionary<State,String>()
    var images          = Dictionary<State,UIImage>()
    var bgColors        = Dictionary<State,UIColor>()
    var bgImages        = Dictionary<State,UIImage>()
    var textColors      = Dictionary<State,UIColor>()
    var attributeTexts  = Dictionary<State,NSAttributedString>()
    
    convenience init(style: Style) {
        self.init(frame: .zero)
        self.fetch(style)
    }
    
    
    //MARK: - init
    override func onSetup() {
        addSubviews([icon,lab])
        icon.contentMode = .scaleAspectFit
        lab.textColor = .black
    }
    
    //MARK: - Setter
    func set(_ title: String?, for state: State = .normal) {
        texts[state] = title
        onStateDidChaned()
    }
    
    func set(_ color: UIColor?, for state: State = .normal) {
        textColors[state] = color
        onStateDidChaned()
    }
    
    func set(_ font: UIFont?, for state: State = .normal) {
        fonts[state] = font
        onStateDidChaned()
    }
    
    func set(_ attribute: NSAttributedString?, for state: State = .normal) {
        attributeTexts[state] = attribute
        onStateDidChaned()
    }
    
    func set(_ image: UIImage?, for state: State = .normal) {
        images[state] = image
        onStateDidChaned()
    }
    
    func set(backgournd color: UIColor?, for state: State = .normal) {
        bgColors[state] = color
        onStateDidChaned()
    }
    
    func set(backgournd image: UIImage?, for state: State = .normal) {
        bgImages[state] = image
        onStateDidChaned()
    }
    
    func set(_ title: String, font: UIFont, color: UIColor, icon: UIImage? = nil, for state: State = .normal) {
        images[state] = icon
        texts[state] = title
        fonts[state] = font
        textColors[state] = color
        
        self.lab.text = title
        self.lab.font = font
        self.lab.textColor = color
        self.icon.image = icon
    }
    
    //MARK: - Layout
    
    enum Style {
        case image(size: CGFloat)
        case paddingImg(padding: CGFloat, size: CGFloat)
        case label
        case paddingLab(padding: CGFloat)
        case imgLab(leading: CGFloat, size: CGFloat, spacing: CGFloat, trailling: CGFloat)
        case labImg(leading: CGFloat, size: CGFloat, spacing: CGFloat, trailling: CGFloat)
        case topImgLab(top: CGFloat, size: CGFloat, spacing: CGFloat, bottom: CGFloat)
        case centerImgLab(size: CGFloat, spacing: CGFloat)
        case centerLabImg(size: CGFloat, spacing: CGFloat)
    }
    
    
    func fetch(_ style: Style) {
        switch style {
        case .image(let size):
            lab.isHidden = true
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(size)
            }
        case .paddingImg(let padding, let size):
            lab.isHidden = true
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(size)
                make.left.lessThanOrEqualTo(padding)
                make.right.greaterThanOrEqualTo(-padding)
            }
        case .label:
            lab.isHidden = false
            icon.isHidden = true
            lab.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
        case .paddingLab(let padding):
            lab.isHidden = false
            icon.isHidden = true
            lab.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.left.lessThanOrEqualTo(padding)
                make.right.greaterThanOrEqualTo(-padding)
            }
        case .imgLab(let leading, let size, let spacing, let trailling):
            lab.isHidden = false
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(size)
                make.left.equalTo(leading)
            }
            
            lab.snp.remakeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(spacing)
                make.right.equalTo(-trailling)
                make.centerY.equalToSuperview()
            }
        case .labImg(let leading, let size,let spacing, let trailling):
            lab.isHidden = false
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(size)
                make.left.equalTo(lab.snp.right).offset(spacing)
                make.right.equalTo(-trailling)
            }
            
            lab.snp.remakeConstraints { make in
                make.left.equalTo(leading)
                make.centerY.equalToSuperview()
            }
        case .centerImgLab(let size,let spacing):
            lab.isHidden = false
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(size)
                make.centerX.equalToSuperview().offset(-(size  + spacing * 0.5))
            }
            
            lab.snp.remakeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(spacing)
                make.centerY.equalToSuperview()
            }
        case .centerLabImg(let size,let spacing):
            lab.isHidden = false
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(size)
                make.left.equalTo(lab.snp.left).offset(size / 2.0 + spacing / 2.0)
            }
            
            lab.snp.remakeConstraints { make in
                make.right.equalTo(icon.snp.left).offset(-spacing)
                make.centerY.equalToSuperview()
            }
        case .topImgLab(let top,let size,let spacing,let bottom):
            lab.isHidden = false
            icon.isHidden = false
            icon.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(size)
                make.top.equalTo(top)
            }
            
            lab.snp.remakeConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(spacing)
                make.centerX.equalToSuperview()
                make.bottom.lessThanOrEqualTo(-bottom)
            }
        }
    }
    
//    func addBackgroundImgView() {
//        guard backgroundImageView.superview == nil else {return}
//        addSubview(backgroundImageView)
//        self.insertSubview(backgroundImageView, at: 0)
//        backgroundImageView.snp.remakeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
    
    @MainActor
    @objc  dynamic  func onStateDidChaned() {
        if !self.images.isEmpty {
            self.icon.image      = images[state] ?? images[State.normal] ?? self.icon.image
        }
        if !self.fonts.isEmpty {
            self.lab.font        = fonts[state] ??  fonts[State.normal] ?? self.lab.font
        }
        
        if texts.isEmpty {
            self.lab.attributedText = attributeTexts[state] ?? attributeTexts[State.normal] ?? self.lab.attributedText
        } else {
            self.lab.text = texts[state] ?? texts[State.normal] ??  self.lab.text
        }
        if !textColors.isEmpty {
            self.lab.textColor   = textColors[state] ?? textColors[State.normal] ?? self.lab.textColor
        }
        if !bgColors.isEmpty {
            self.backgroundColor = bgColors[state] ?? bgColors[State.normal] ?? self.backgroundColor
        }
        
        
        

    }
    
    
    
    //MARK: - Gesture action
    private var onTapGes: UITapGestureRecognizer?
    var onTap: FBCallback? {
        didSet {
            if onTap != nil {
                self.isUserInteractionEnabled = true
                onTapGes = UITapGestureRecognizer(target: self, action: #selector(onTapped))
                addGestureRecognizer(onTapGes!)
            } else {
                self.isUserInteractionEnabled = false
                onTapGes?.removeTarget(self, action: #selector(onTapped))
            }
        }
    }
    
    @objc func onTapped() {
        onTap?()
    }
    

    
}
