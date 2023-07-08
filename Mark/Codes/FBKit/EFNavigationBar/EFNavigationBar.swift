//
//  EFNavigationBar.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//


import Foundation
import UIKit
//import SwifterSwift

@IBDesignable class EFNavigationBar: UIView {
    
    static var defaultStyle: EFNavigationBarConfig = EFNavigationBarConfig()
    
    var onLeftButtonClick: (()->())?
    var onRightButtonClick: (()->())?
    
    var title: String? {
        willSet {
            titleLabel.text = newValue
        }
    }
    var barBackgroundColor: UIColor? {
        willSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = newValue
        }
    }
    var barBackgroundImage: UIImage? {
        willSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = newValue
        }
    }
    
    // UI variable
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = EFNavigationBar.defaultStyle.title
        label.textColor = .black
        label.font = EFNavigationBar.defaultStyle.titleFont
        label.textAlignment = .center
        return label
    }()
    
    
    
    lazy var leftButton = FBLab().then { button in
        let button = FBLab()
        button.set(EFNavigationBar.defaultStyle.buttonTitleColor)
        button.set(EFNavigationBar.defaultStyle.buttonTitleFont)
        button.imageView.contentMode = .center
        button.isHidden = true
//        button.addTarget(self, action: #selector(clickLeft), for: .touchUpInside)
        button.onTap = { [weak self]  in
            self?.clickLeft()
        }
    }
    
    /// 最右
    lazy var rightButton = FBLab().then { button in
        button.set(EFNavigationBar.defaultStyle.buttonTitleColor)
        button.set(EFNavigationBar.defaultStyle.buttonTitleFont)
        button.imageView.contentMode = .center
        button.isHidden = true
    }
    
    lazy var rightButton2 = FBLab().then { button in
        button.set(EFNavigationBar.defaultStyle.buttonTitleColor)
        button.set(EFNavigationBar.defaultStyle.buttonTitleFont)
        button.imageView.contentMode = .center
        button.isHidden = true
    }
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = EFNavigationBar.defaultStyle.bottomLineColor
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = EFNavigationBar.defaultStyle.backgroundColor
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()
    
    // init
    class func CustomNavigationBar() -> EFNavigationBar {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: EFNavigationBar.defaultStyle.height)
        return EFNavigationBar(frame: frame)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(bottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
//        isUserInteractionEnabled = true
    }
    func updateFrame() {
        let top: CGFloat = k_status_bar_height
        let margin: CGFloat = EFNavigationBar.defaultStyle.buttonMargin
        let buttonHeight: CGFloat = EFNavigationBar.defaultStyle.buttonHeight
        let buttonWidth: CGFloat = EFNavigationBar.defaultStyle.buttonWidth
        let titleLabelHeight: CGFloat = EFNavigationBar.defaultStyle.titleHeight
        let titleLabelWidth: CGFloat = EFNavigationBar.defaultStyle.titleWidth
        
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        leftButton.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: UIScreen.main.bounds.size.width - buttonWidth - margin, y: top, width: buttonWidth, height: buttonHeight)
        titleLabel.frame = CGRect(x: (UIScreen.main.bounds.size.width - titleLabelWidth) / 2.0, y: top, width: titleLabelWidth, height: titleLabelHeight)
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: UIScreen.main.bounds.size.width, height: 0.5)
        
        leftButton.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalTo(fixScaleFor414(-9))
            $0.height.equalTo(44)
        }
        
    }
}

extension EFNavigationBar {
    func setBottomLineHidden(hidden: Bool) {
        bottomLine.isHidden = hidden
    }
    
    func setBackgroundAlpha(alpha: CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
        bottomLine.alpha = alpha
    }
    
    func setTitleColor(color: UIColor) {
        titleLabel.textColor = color
    }
    
    func setTintColor(color: UIColor) {
        leftButton.set( color, for: .normal)
        rightButton.set( color, for: .normal)
    }
    
    // 左右按钮共有方法
    func setLeftButton(normal: UIImage, highlighted: UIImage) {
        setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
        leftButton.fetch(.image(size: 20))
    }
    func setLeftButton(image: UIImage?) {
        setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
        leftButton.fetch(.image(size: 20))
    }
    func setLeftButton(title: String, titleColor: UIColor) {
        setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
        leftButton.fetch(.paddingLab(padding: 9))
        leftButton.set( UIFont.medium(16))
    }
    
    func setRightButton(normal: UIImage?, highlighted: UIImage?) {
        setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
        rightButton.fetch( .image(size: 20))
    }
    
    func setRightButton(image: UIImage?) {
        setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
        rightButton.fetch( .image(size: 20))
    }
    
    func setLeftButton(image: UIImage?, selected: UIImage?, done: @escaping FBCallback) {
        leftButton.isHidden = false
        leftButton.set(image)
        leftButton.set(selected)
        leftButton.set(title)
        leftButton.fetch(.image(size: 20))
        leftButton.onTap = done
        leftButton.snp.remakeConstraints { make in
            make.left.equalTo(5)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    func setRightButton(image: UIImage?, selected: UIImage?, done: @escaping FBCallback) {
        rightButton.isHidden = false
        rightButton.set(image)
        rightButton.set(selected, for: .selected)
        rightButton.set(title)
        rightButton.fetch(.image(size: 20))
        rightButton.onTap = done
        rightButton.snp.remakeConstraints { make in
            make.right.equalTo(-5)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    func setRightButton2(image: UIImage?, selected: UIImage?, done: @escaping FBCallback) {
        rightButton2.isHidden = false
        rightButton2.set(image, for: .normal)
        rightButton2.set(selected, for: .selected)
        rightButton2.set(title, for: .normal)
        rightButton2.fetch( .image(size: 20))
        rightButton2.onTap = done
        addSubview(rightButton2)
        rightButton2.snp.remakeConstraints { make in
            make.right.equalTo(rightButton.snp.left)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    func setRightButton(title: String, titleColor: UIColor) {
        setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
        rightButton.fetch( .paddingLab(padding: 9))
        rightButton.set( .medium(16))
    }
    
    // 左右按钮私有方法
    private func setLeftButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        setButton(isLeft: true, normal: normal, highlighted: highlighted, title: title, titleColor: titleColor)
    }
    private func setRightButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        setButton(isLeft: false, normal: normal, highlighted: highlighted, title: title, titleColor: titleColor)
    }
    
    private func setButton(isLeft: Bool, normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        let button: FBLab = isLeft ? leftButton : rightButton
        button.isHidden = false
        button.set(normal, for: .normal)
        button.set(highlighted, for: .selected)
        button.set(title, for: .normal)
        button.set(titleColor, for: .normal)
    }
}

// MARK: - 导航栏左右按钮事件
extension EFNavigationBar {
    
    @objc func clickLeft() {
        if let onClickLeft = onLeftButtonClick {
            onClickLeft()
        } else {
            UIViewController.topViewController.goBack(animated: true)
        }
    }
    
    @objc func clickRight() {
        if let onClickRight = onRightButtonClick {
            onClickRight()
        }
    }
}


//MARK: - EFNavigationBarConfig
struct EFNavigationBarConfig {
    
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
    
    var title: String?
    var height: CGFloat = k_nav_bar_height //CGFloat.statusBarAndNavigationBarHeight
    var backgroundColor: UIColor = UIColor.white
    
    var bottomLineColor: UIColor =  .line//UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    
    var titleColor: UIColor = UIColor.black
    var titleSize: CGFloat = 18 {
        didSet {
            titleFont = UIFont.systemFont(ofSize: titleSize)
        }
    }
    var titleFont: UIFont = UIFont.semibold(20)
    let titleHeight: CGFloat =  44 //CGFloat.navigationBarHeight
    let titleWidth: CGFloat = k_window_width - 2 * 44
    
    var buttonTitleColor: UIColor = UIApplication.shared.keyWindow()?.tintColor ?? UIColor.black
    var buttonTitleSize: CGFloat = UIFont.labelFontSize {
        didSet {
            buttonTitleFont = UIFont.systemFont(ofSize: buttonTitleSize)
        }
    }
//    var buttonTitleFont: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    var buttonTitleFont: UIFont = UIFont.medium(16)
    var buttonMargin: CGFloat = 5
    var buttonWidth: CGFloat = 44
    var buttonHeight: CGFloat = 44
}

//MARK: - UINavigationController
extension UINavigationController {
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.topViewController.statusBarStyle ?? EFNavigationBar.defaultStyle.statusBarStyle
    }
}

//MARK: - UIViewController
fileprivate struct AssociatedKeys {
    static var statusBarStyle: String = "statusBarStyle"
}

extension UIViewController {
    
    var statusBarStyle: UIStatusBarStyle {
        get {
            guard let style = objc_getAssociatedObject(self, &AssociatedKeys.statusBarStyle) as? UIStatusBarStyle else {
                return EFNavigationBar.defaultStyle.statusBarStyle
            }
            return style
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    
    var topViewController: UIViewController {
        return presentedViewController?.topViewController
            ?? (self as? UITabBarController)?.selectedViewController?.topViewController
            ?? (self as? UINavigationController)?.visibleViewController?.topViewController
            ?? self
    }
    
    static var topViewController: UIViewController {
        return UIApplication.shared.delegate?.window??.rootViewController?.topViewController ?? UIViewController()
    }
    
    func goBack(animated: Bool, completion: (() -> Void)? = nil) {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated) { [weak self] in
                guard let _ = self else { return }
                completion?()
            }
        } else if nil != self.presentingViewController {
            self.dismiss(animated: animated, completion: completion)
        }
    }
}

//MARK: - UIApplication
extension UIApplication {

    func keyWindow() -> UIWindow? {
        let currentApplication = UIApplication.shared
        var targetWindow = currentApplication.keyWindow
        if #available(iOS 13.0, tvOS 13.0, *) {
            let scenes = currentApplication.connectedScenes.filter({ $0.activationState == .foregroundActive })
            var findNormalWindow: Bool = false
            for scene in scenes where !findNormalWindow {
                if let windowScene = scene as? UIWindowScene {
                    for keyWindow in windowScene.windows.filter({ $0.isKeyWindow }) where !findNormalWindow {
                        if keyWindow.windowLevel != .normal {
                            let windows = currentApplication.windows
                            for temp in windows where (!findNormalWindow && temp.windowLevel == .normal) {
                                targetWindow = temp
                                findNormalWindow = true
                                break
                            }
                        } else {
                            targetWindow = keyWindow
                            findNormalWindow = true
                            break
                        }
                    }
                }
            }
        } else {
            if let keyWindow = targetWindow, keyWindow.windowLevel != .normal {
                let windows = currentApplication.windows
                for temp in windows {
                    if temp.windowLevel == .normal {
                        targetWindow = temp
                        break
                    }
                }
            }
        }
        return targetWindow
    }
}


