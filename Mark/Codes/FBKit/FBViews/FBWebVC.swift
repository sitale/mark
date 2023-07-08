//
//  FBWebVC.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit
import WebKit
import SVProgressHUD

class FBWebVC : FBVC {
    
    convenience init(name: String, uri: String) {
        self.init(nibName: nil, bundle: nil)
        self.name = name
        self.url = uri  
    }
    
    
    var name: String = ""
    var url: String = ""
    
    
    let cfg = WKWebViewConfiguration()
    lazy var webView = WKWebView(frame: .zero, configuration: cfg)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarWhiteBackBtn(name)
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.load(URLRequest(url: URL(string: url)!))
    }
}
