//
//  Input.swift
//  Mark
//
//  Created by licon on 2023/6/27.
//

import UIKit

class InputVC : FBVC, UITextViewDelegate {
    
    let contentView = FBView()
    let inputTextView = UITextView(frame: CGRect(x: fixDevice(18), y: 86, width: fixDevice(299), height: 155))
    let placeholder_lab = UILabel()
    let title_lab = UILabel()
    
    var placedoler = ""
    
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
            make.height.equalTo(347)
        }
        
        contentView.addSubview(title_lab)
        contentView.addSubview(inputTextView)
        contentView.addSubview(placeholder_lab)
        
        
        
        inputTextView.backgroundColor = UIColor(0xE8F7FB )
        inputTextView.cornerRadius = 4
        inputTextView.textColor = .title
        inputTextView.font = .medium(12)
        inputTextView.contentInset = UIEdgeInsets(horizontal: 18, vertical: 15)
        inputTextView.delegate = self
        inputTextView.text = ""
        
        
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
            guard let text = self?.inputTextView.text else { return }
            self?.row.detail = text
            self?.dismiss(animated: false)
        }
        placeholder_lab.set("", .regular(12), color: .detail)
        placeholder_lab.snp.makeConstraints { make in
            make.left.equalTo(inputTextView.snp.left).offset(18)
            make.top.equalTo(inputTextView.snp.top).offset(15)
        }
        
        title_lab.set("", .semibold(16), color: UIColor(0x0B1A27))
        title_lab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(23)
        }
        
        inputTextView.text = row.detail
        title_lab.text = row.title
        placeholder_lab.text = row.placeholder
    }
    
    var row: MarkModel.Row!
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholder_lab.alpha = textView.text.count > 0 ? 0 : 1
    }
}
