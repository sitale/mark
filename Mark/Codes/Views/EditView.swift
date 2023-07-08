//
//  EditView.swift
//  Mark
//
//  Created by jyck on 2023/6/27.
//

import UIKit
import SVProgressHUD

class EditView : FBVC {
    
    
    let contentView = FBView()
    let titleLab = UILabel()
    
    let offset: CGFloat = 55
    
    let leftBtn     = FBLab()
    let rightBtn    = FBLab()
    
    var style: MarkModel.Style = .geo

    var onTapDone: FBCallback?
    
    convenience init(style: MarkModel.Style ) {
        self.init(nibName: nil, bundle: nil)
        self.style = style
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.isHidden = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(fixDevice(335))
        }
        contentView.backgroundColor = .white
        contentView.cornerRadius = 4
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(23)
        }
        titleLab.set("编辑水印", .semibold(18), color: UIColor(0x0B1A27))
        

        let array = FBShared.shared.rows[style]!.enumerated().map { obj in
            return EditRow().then({
                $0.config(row: obj.element)
                $0.frame  = CGRect(x: 0, y: self.offset + obj.offset.cgFloat * 54, width: fixDevice(334), height: 54)
            })
        }
        contentView.addSubviews(array)
        
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
            make.top.equalTo(array.last!.snp.bottom).offset(24).priority(800)
            make.bottom.equalTo(-27)
        }
        
        leftBtn.onTap = { [weak self] in
            self?.dismiss(animated: true)
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
            let onTapDone = self?.onTapDone
            self?.dismiss(animated: true, completion: onTapDone)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.alpha = 1
    }
    
}


class EditRow : FBTile {

    override func onSetup() {
        super.onSetup()

        set("", font: .regular(14), color: .black, icon: UIImage(named: "Ellipse 468"))
        set(UIImage(named: "Vector"), for: .selected)
        fetch(.imgLab(leading: 20, size: 20, spacing: 9, trailling: 0))
        
        arrow.fetch(.image(size: 20))
        arrow.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.right.equalTo(-12)
        }
        addLine(.bottom, lineWidth: 1, margin: 22)
        arrow.onTap = { [weak self] in
            self?.onTap()
        }
        
        onTap = { [weak self] in
            guard let self else { return }
            self.row.isSelected = !self.row.isSelected
            self.isSelected = self.row.isSelected
        }
    }
    

    func config(_ title: String, showArrow: Bool, isSelected: Bool) {
        set(title)
        self.isSelected = isSelected
        arrow.set(UIImage(named: showArrow ? "Frame(12)" : "Frame(11)"))
    }
    
    var row: MarkModel.Row!
    func config(row: MarkModel.Row) {
        self.row = row
        config(row.title, showArrow: row.isInput || row.isPickerData, isSelected: row.isSelected)
    }
    
    deinit {
        print(" deinit ")
    }
    
    
    func onTap() {
        if row.isInput {
            let vc = InputVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.row = row
            currentViewController()?.present(vc, animated: false)
        } else if row.isPickerData {
            let pickVC = DatePicker()
            pickVC.row = row
            pickVC.modalPresentationStyle = .overCurrentContext
            currentViewController()?.present(pickVC, animated: false)
        } else {
            SVProgressHUD.show()
            FBShared.shared.start() {
                SVProgressHUD.dismiss()
            }
        }
    }
}
