//
//  drawer.swift
//  Mark
//
//  Created by jyck on 2023/6/26.
//

import UIKit
import GYSide

class Drawer : FBVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let effect = UIBlurEffect(style: .light)
        
        let blurView = UIVisualEffectView(effect: effect)
        
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        navBar.isHidden = true
        
        let closeBtn = FBLab(frame: CGRect(x: 24, y: k_status_bar_height + 9, width: 44, height: 44))
        view.addSubview(closeBtn)
        closeBtn.set(UIImage(named: "Frame 673"))
        closeBtn.onTap = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let cornerView = FBView(frame: CGRect(x: 24, y: closeBtn.frame.maxY + 43, width: fixDevice(230), height: 80), background: UIColor(0xE8F7FB), corner: 22)
        view.addSubview(cornerView)
        
        
        if StoreManager.shared.isBuyVip {
            UIImageView(CGRect(x: 0, y: 17, width: 72, height: 64), image: UIImage(named: "image 2"), superview: cornerView)
            
            UIImageView(CGRect(x: fixDevice(80), y: 9, width: fixDevice(140), height: 62), image: UIImage(named: "已解锁所有高级功能"), superview: cornerView)
        } else {
            UIImageView(CGRect(x: 15, y: 10, width: 92, height: 62), image: UIImage(named: "解锁所有高级功能"), superview: cornerView)
            
            let btn = FBLab(frame: CGRect(x: fixDevice(128), y: 26, width: fixDevice(86), height: 37))
            btn.fetch(.label)
            btn.set(backgournd: UIColor(0xF65757))
            btn.set("立即开通", font: .regular(14), color: .white)
            btn.addCorner(.allCorners, radius: 37 * 0.5)
            cornerView.addSubview(btn)
            btn.onTap = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    currentViewController()?.navigationController?.pushViewController(Store())
                })
            }
        }

        
        let btn1 = FBTile(frame: CGRect(x: 0, y: cornerView.frame.maxY + 45, width: view.width, height: 36))
        btn1.set("隐私协议", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319820"))
        btn1.fetch(.imgLab(leading: 26, size: 36, spacing: 10, trailling: 0))
        view.addSubview(btn1)
        btn1.onTap = { [weak self] in
            self?.dismiss(animated: true, completion: {
                StoreManager.showUserAgreement()
            })
        }
        
        let btn2 = FBTile(frame: CGRect(x: 0, y: btn1.frame.maxY + 45, width: view.width, height: 36))
        btn2.set("当前版本", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319821"))
        btn2.fetch(.imgLab(leading: 26, size: 36, spacing: 10, trailling: 0))
        view.addSubview(btn2)
        btn2.onTap = { [weak self] in
            self?.dismiss(animated: true, completion: {
                currentViewController()?.navigationController?.pushViewController(Version())
            })
        }
        
        
        let btn3 = FBTile(frame: CGRect(x: 0, y: btn2.frame.maxY + 45, width: view.width, height: 36))
        btn3.set("服务条款", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319822"))
        btn3.fetch(.imgLab(leading: 26, size: 36, spacing: 10, trailling: 0))
        view.addSubview(btn3)
        btn3.onTap = { [weak self] in
            self?.dismiss(animated: true, completion: {
                StoreManager.showUserPrivacy()
            })
            
        }
        
        
        let btn4 = FBTile(frame: CGRect(x: 0, y: btn3.frame.maxY + 45, width: view.width, height: 36))
        btn4.set("分享应用", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319823"))
        btn4.fetch(.imgLab(leading: 26, size: 36, spacing: 10, trailling: 0))
        view.addSubview(btn4)
        btn4.onTap = { [weak self] in
            self?.dismiss(animated: true, completion: {
                StoreManager.showShareVC()
            })
            
        }
        
    }
}
