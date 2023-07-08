//
//  Card5.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

class Card5 : CardView {
    let title_lab = FBLab()
    let time_lab  = UILabel()
    let addr_lab  = UILabel()
    

    override func onSetup() {
        super.onSetup()
        
        title_lab.cornerRadius = 4
        title_lab.borderWidth = 2
        title_lab.borderColor = UIColor(0xD9D9D9)
        
        title_lab.set("现场拍照", font: .semibold(20), color: UIColor(0xD9D9D9))
        title_lab.fetch(.label)
        
        
        addr_lab.set("地址: 厦门海滨路66号惠中科技大厦", .regular(10), color: .white, numberOfLines: 0)
        
        time_lab.set("时间: \(date.string(withFormat: "yyyy-MM-dd HH:mm"))", .regular(10), color: .white)
        
        let array = [title_lab, time_lab, addr_lab]
        stcakView.addArrangedSubviews(array)
        title_lab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(fixDevice(132))
        }
        
        time_lab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(fixDevice(132))
        }
        
        addr_lab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(fixDevice(132))
        }
    }
    
    
    override func config(_ rows:[MarkModel.Row]) {
        super.config(rows)
        stcakView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stcakView.removeArrangedSubviews()
        var array:[UIView] = [title_lab]
        
        
        if rows[0].isSelected {
            array.append(addr_lab)
            addr_lab.text = "地址: \(rows[0].detail)"
        }
        
        if rows[1].isSelected {
            array.append(time_lab)
            time_lab.text = "时间: \(date.string(withFormat: "yyyy-MM-dd HH:mm"))"
        }
        
        stcakView.addArrangedSubviews(array)
        title_lab.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(fixDevice(132))
        }

        if rows[0].isSelected {
            addr_lab.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(fixDevice(132))
            }
        }
        if rows[1].isSelected {
            time_lab.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(fixDevice(132))
            }
        }
    }
    
    
}
