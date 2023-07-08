//
//  FBVC.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit

class FBVC : UIViewController , UIGestureRecognizerDelegate {
    let navBar = EFNavigationBar.CustomNavigationBar().then {
        $0.barBackgroundColor = .white
        $0.setBottomLineHidden(hidden: true)
        $0.titleLabel.font = .medium(16)
        $0.titleLabel.textColor = .black
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(navBar)
    }
    
    // 让导航栏处于最顶层防止被子类遮挡
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(navBar)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupNavBarWhiteBackBtn(_ title: String, color: UIColor = .black) {
        setupBackBtnImage(UIImage(named: "back (1)")?.template)
        navBar.leftButton.imageView.tintColor = color
        navBar.title = title
        navBar.setTitleColor(color: .title)
        navBar.leftButton.fetch(.image(size: 24))
        navBar.leftButton.onTap = { [weak self] in
            self?.onTapBackAction()
        }
    }
    
    
    private func setupBackBtnImage(_ image: UIImage?) {
        navBar.setLeftButton(image: image)

        navBar.leftButton.snp.remakeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
            $0.left.equalTo(12)
        }
        
        navBar.leftButton.imageView.contentMode = .scaleAspectFit
        navBar.leftButton.imageView.snp.remakeConstraints { make in
            make.width.equalTo(10)
            make.height.equalTo(17)
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
        }
    }
    
    
    
    //MAKR: - UIGestureRecognizerDelegate
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if canBack() {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    
    /// 返回响应方法，可重构
    @objc dynamic func onTapBackAction(){
        if canBack() {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 是否允许关闭
    @objc dynamic func canBack() -> Bool {
        let count = self.navigationController?.children.count ?? 0
        return count > 1
    }
    
    
    @objc dynamic func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return canBack()
    }
    
    @objc dynamic func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return canBack()
    }
    
}
