//
//  DatePicker.swift
//  Mark
//
//  Created by licon on 2023/6/27.
//

import UIKit

class DatePicker : FBVC {
    
    let contentView = FBView()
    let picker = UIDatePicker(frame: CGRect(x: fixDevice(18), y: 42, width: fixDevice(299), height: fixDevice(420)))
    let title_lab = UILabel()
    
    let leftBtn     = FBLab()
    let rightBtn    = FBLab()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        navBar.isHidden = true
        contentView.backgroundColor = .white
        contentView.cornerRadius = 4
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(fixDevice(335))
            make.height.equalTo(520)
        }
        
        contentView.addSubview(title_lab)
        contentView.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100).isActive = true
        picker.backgroundColor = .white
        picker.locale = Locale(identifier: "zh_CN")
        picker.addTarget(self, action: #selector(onPickerChaned), for: .valueChanged)
//        picker.frame = CGRect(x: 0, y: 0, width: k_window_width, height: k_window_width / 2.0)
//            picker.center = CGPoint(x: k_window_width / 2.0, y: k_window_height / 2.0)
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        picker.datePickerMode = .dateAndTime
//        self.inputView = picker
        
        contentView.addSubviews([leftBtn, rightBtn])
        
        leftBtn.cornerRadius = 4
        leftBtn.borderColor = .theme
        leftBtn.borderWidth = 1.0
        leftBtn.set("取消", font: .semibold(16), color: .theme)
        leftBtn.fetch(.label)
        leftBtn.snp.makeConstraints { make in
            make.width.equalTo(fixDevice(120))
            make.height.equalTo(46)
            make.left.equalTo(fixDevice(18))
            make.bottom.equalTo(-27)
        }
        
        leftBtn.onTap = { [weak self] in
            self?.dismiss(animated: false)
        }
        
        rightBtn.cornerRadius = 4
        rightBtn.set(backgournd: .theme)
        rightBtn.set("确定", font: .semibold(16), color: .white)
        rightBtn.fetch(.label)
        rightBtn.snp.makeConstraints { make in
            make.width.equalTo(fixDevice(120))
            make.height.equalTo(46)
            make.right.equalTo(fixDevice(-18))
            make.centerY.equalTo(leftBtn.snp.centerY)
        }
        rightBtn.onTap = { [weak self] in
//            guard let text = self?.inputTextView.text else { return }
//            self?.row.detail = text
            self?.dismiss(animated: false)
        }

        title_lab.set("选择日期", .semibold(16), color: UIColor(0x0B1A27))
        title_lab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(23)
        }
    
    }
    
    @objc func onPickerChaned() {
        printt("Date:\(picker.date)")
        FBShared.shared.date = picker.date
        NotificationCenter.default.post(name: .onLoadLocationNotification, object: nil)
    }
    
    var row: MarkModel.Row!
    
}
