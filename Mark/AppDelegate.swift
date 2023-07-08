//
//  AppDelegate.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        StoreManager.shared.setupKit()
        FBShared.shared.onSetup()
        let version = "1.0"
        if !UserDefaults.standard.bool(forKey: version) {
            let vc = Intro()
            vc.actionHandler = { [weak self] in
                UserDefaults.standard.set(true, forKey: version)
                UserDefaults.standard.synchronize()
                self?.update(root: UINavigationController(rootViewController: Store()))
            }
            update(root: vc)
        } else {
            if StoreManager.shared.isBuyVip {
                enter()
            } else {
                self.update(root: UINavigationController(rootViewController: Store()))
            }
        }
#if targetEnvironment(simulator)
        //UMConfigure.initWithAppkey("6354d84b88ccdf4b7e51b2fe", channel: "Dev")
#else
        UMConfigure.initWithAppkey(FBPublishConfig.appId, channel: "Dis")
#endif
        return true
    }


    func enter() {
        update(root: UINavigationController(rootViewController: ViewController()))
    }
    
    func update(root controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.layer.add(transition, forKey: "animation")
        self.window?.backgroundColor = .darkGray
        self.window?.removeSubviews()
        self.window?.rootViewController?.removeFromParent()
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }

}

