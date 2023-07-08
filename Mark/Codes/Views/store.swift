//
//  store.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit
import SwifterSwift

class Store : FBVC {
    
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarWhiteBackBtn("开通")
        navBar.setBackgroundAlpha(alpha: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.backgroundColor = UIColor(0xF4D2CB)
        scrollView.addSubview(contentView)
        scrollView.bounces = false
//        contentView.backgroundColor = UIColor(0xF4D2CB)

        
        let corner = FBView(frame: .zero, background: UIColor(0xE8F7FB), corner: 16, superview: contentView).then {
            $0.snp.makeConstraints { make in
                make.left.equalTo(21)
                make.right.equalTo(-21)
                make.height.equalTo(129)
                make.top.equalTo(navBar.snp.bottom).offset(30)
            }
        }
        
        let _ = UIImageView(CGRect(x: 22, y: 29, width: 96, height: 32), image: UIImage(named: "升级会员"), superview: corner)
        
        let _ = UIImageView(CGRect(x: 22, y: 68, width: 132, height: 30), image: UIImage(named: "解锁所有权限"), superview: corner)
        
        
        let icon_1 = UIImageView(.zero, image: UIImage(named: "Frame 427319876"), superview: contentView)
        icon_1.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(144)
            make.top.equalTo(k_nav_bar_height + 8)
            make.right.equalTo(-39)
        }
        
        
        let stackView = UIStackView(frame: .zero )
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
//            make.left.equalTo(31)
            make.centerX.equalToSuperview()
            make.height.equalTo(116 - 24)
//            make.right.equalTo(31)
            make.top.equalTo(corner.snp.bottom).offset(24)
        }
        stackView.axis = .horizontal
        stackView.spacing = (view.width - 64 - 54 * 4) / 3
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews([
            FBLab().then({
                $0.set("无广告", font: .medium(12), color: .title, icon: UIImage(named: "Frame 427319875"))
                $0.fetch(.topImgLab(top: 0, size: 54, spacing: 7, bottom: 0))
                $0.snp.makeConstraints { make in
                    make.width.equalTo(54)
                }
            }),
            FBLab().then({
                $0.set("多种模板", font: .medium(12), color: .title, icon: UIImage(named: "Frame 427319874"))
                $0.fetch(.topImgLab(top: 0, size: 54, spacing: 7, bottom: 0))
                $0.snp.makeConstraints { make in
                    make.width.equalTo(54)
                }
            }),
            FBLab().then({
                $0.set("自定义水印", font: .medium(12), color: .title, icon: UIImage(named: "Frame 427319872"))
                $0.fetch(.topImgLab(top: 0, size: 54, spacing: 7, bottom: 0))
                $0.snp.makeConstraints { make in
                    make.width.equalTo(54)
                }
            }),
            FBLab().then({
                $0.set("视频水印", font: .medium(12), color: .title, icon: UIImage(named: "Frame 427319873"))
                $0.fetch(.topImgLab(top: 0, size: 54, spacing: 7, bottom: 0))
                $0.snp.makeConstraints { make in
                    make.width.equalTo(54)
                }
            }),
        ])
        
        let bottomCorner = FBView(frame: CGRect(x: 0, y: 363 - 88 + k_nav_bar_height, width: view.width, height: 419 + k_safe_tabbar_bottom), background: .white, corner: 0)
        bottomCorner.addCorner([.topLeft, .topRight], radius: 40)
        bottomCorner.onLayoutCallback = { v in
            v.addCorner([.topLeft, .topRight], radius: 40)
        }
        contentView.addSubview(bottomCorner)
        bottomCorner.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(419 + k_safe_tabbar_bottom)
            make.bottom.equalToSuperview()
        }
        bottomCorner.setNeedsLayout()
        

        contentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(view.width)
            make.height.greaterThanOrEqualTo(self.view.height)
//            make.bottom.equalToSuperview()
        }
        let text_1 = "免费试用3天，随后¥298/年，获得APP的完全访问权限，随时取消。        "
        let attri  = NSMutableAttributedString(string: text_1)
        attri.addAttributes([.foregroundColor: UIColor( 0x4086F9)], range:  (text_1 as NSString).range(of: "¥298/年"))
        let lab_1 = UILabel(.zero, "", UIColor(0x717171), font: .medium(12), superview: bottomCorner)
        lab_1.attributedText = attri
        lab_1.numberOfLines = 0
        lab_1.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(fixDevice(51))
            make.right.equalTo(-31)
        }
        
        let title = FBShared.shared.date2.string(withFormat: "yyyyMMdd").int! > 20230713 ? "继续试用"  : "免费试用3天，随后¥298/年"
        let doneBtn = FBLab()
        doneBtn.fetch(.label)
        bottomCorner.addSubview(doneBtn)
        doneBtn.backgroundColor = .theme
        doneBtn.set(title, font: .medium(16), color: .white)
        doneBtn.cornerRadius = 27
        doneBtn.snp.makeConstraints { make in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(54)
            make.top.equalTo(lab_1.snp.bottom).offset(fixDevice(11))
        }
        doneBtn.onTap = { [weak self] in
            StoreManager.purchaseProduct()
        }
        
        
        let line1 = FBGradient(frame: CGRect(x: 0, y: 0, width: 75, height: 2))
        line1.gradientLayer.colors = [UIColor(0x64CCE1).cgColor, UIColor(0xE8F7FB).cgColor]
        line1.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        line1.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let line2 = FBGradient(frame: CGRect(x: 0, y: 0, width: 75, height: 2))
        line2.gradientLayer.colors = [UIColor(0x64CCE1).cgColor, UIColor(0xE8F7FB).cgColor]
        line2.gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        line2.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        
        let line_text = UILabel(.zero, "订阅须知", .theme, font: .medium(14))
        
        bottomCorner.addSubviews([line1, line2, line_text])
        line_text.snp.makeConstraints { make in
            make.top.equalTo(doneBtn.snp.bottom).offset(fixDevice(57))
            make.centerX.equalToSuperview()
        }
        
        line1.snp.makeConstraints { make in
            make.right.equalTo(line_text.snp.left).offset(-15)
            make.centerY.equalTo(line_text.snp.centerY)
            make.width.equalTo(75)
            make.height.equalTo(2)
        }
        
        line2.snp.makeConstraints { make in
            make.left.equalTo(line_text.snp.right).offset(15)
            make.centerY.equalTo(line_text.snp.centerY)
            make.width.equalTo(75)
            make.height.equalTo(2)
        }
        
        let lab_2 = UILabel(.zero, "当您确定订阅并付款后，您的iTunes账号费用将被收取，如需取消订阅至少需要提前24h关闭自动订阅否则将自动续订，订阅成功后会在下一个订阅周期完成时自动续订，订阅价格为 ¥298/年，免费试用3天，解锁全部高级功能，可随时取消。", UIColor(0xA5A5A5), font: .regular(12), superview: bottomCorner)
        lab_2.numberOfLines = 0
        lab_2.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(line_text.snp.bottom).offset(fixDevice(20))
            make.right.equalTo(-31)
        }
        
        
        
        let bottomStack = UIStackView(arrangedSubviews: [], axis: .horizontal, spacing: 0, alignment: .center, distribution: .equalSpacing)
        bottomCorner.addSubview(bottomStack)
        bottomStack.snp.makeConstraints { make in
//            make.width.equalTo(fixDevice(48))
            make.height.equalTo(fixDevice(20))
            make.centerX.equalToSuperview()
            make.top.equalTo(lab_2.snp.bottom).offset(fixDevice(47)).priority(800)
            make.bottom.lessThanOrEqualTo(fixDevice(-20 - k_safe_tabbar_bottom))
        }
        
        let btn1 = FBLab()
        contentView.addSubview(btn1)
        btn1.fetch( .paddingLab(padding: 12))
        btn1.set("隐私协议", font: .medium(12), color: .c97)
        btn1.snp.makeConstraints { make in
//            make.width.equalTo(fixDevice(48))
            make.height.equalTo(17)
            make.width.equalTo(72)
//            make.centerX.equalToSuperview()
//            make.top.equalTo(lab_2.snp.bottom).offset(fixDevice(47)).priority(800)
//            make.bottom.equalTo(fixDevice(-47))
        }
        
        btn1.onTap =  {
            StoreManager.showUserPrivacy()
        }
        
        let btn2 = FBLab()
        contentView.addSubview(btn2)
        btn2.fetch( .paddingLab(padding: 12))
        btn2.set("服务条款", font: .medium(12), color: .c97)
        btn2.snp.makeConstraints { make in
//            make.width.equalTo(fixDevice(48))
            make.height.equalTo(17)
            make.width.equalTo(72)
//            make.right.equalTo(btn1.snp.left).offset(-fixDevice(30))
//            make.centerY.equalTo(btn1.snp.centerY)
        }
        btn2.onTap =  {
            StoreManager.showUserAgreement()
        }
        
        let btn3 = FBLab()
        contentView.addSubview(btn3)
        btn3.fetch( .paddingLab(padding: 12))
        btn3.set("恢复购买", font: .medium(12), color: .c97)
        btn3.snp.makeConstraints { make in
            make.width.equalTo(72)
//            make.width.equalTo(fixDevice(48))
            make.height.equalTo(17)
//            make.left.equalTo(btn1.snp.right).offset(fixDevice(30))
//            make.centerY.equalTo(btn1.snp.centerY)
        }
        
        btn3.onTap =  {
            StoreManager.restorePurchases()
        }
        let line3 = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 17))
        line3.backgroundColor = .c97
        line3.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(17)
        }
        let line4 = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 17))
        line4.backgroundColor = .c97
        line4.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(17)
        }
        
        bottomStack.addArrangedSubviews([btn1, line3, btn2,line4, btn3])
        
        
    }
    override func onTapBackAction() {
        if self.navigationController?.children.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let delegate = UIApplication.shared.delegate as?  AppDelegate {
                delegate.enter()
            }
        }
    }
    
    
}
