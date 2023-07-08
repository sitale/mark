//
//  version.swift
//  Mark
//
//  Created by jyck on 2023/6/26.
//

import UIKit


class Version : FBVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavBarWhiteBackBtn("版本信息")
        
        let icon = UIImageView(.zero, image: UIImage(named: "logo (1)"), superview: view)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
            make.top.equalTo(240 - 88 + k_nav_bar_height)
        }
        
        let titleLab = UILabel()
        view.addSubview(titleLab)
        titleLab.text = "水印相机"
        titleLab.font = .semibold(24)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(19)
        }
        
        
        let detailLab = UILabel()
        view.addSubview(detailLab)
        detailLab.text = "v1.0"
        detailLab.font = .regular(16)
        detailLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLab.snp.bottom).offset(12)
        }
        
    }
}
