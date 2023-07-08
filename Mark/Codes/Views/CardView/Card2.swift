//
//  Card2.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

class Card2 : CardView {
    
    let timePrefix = FBLab()
    let timeSubfix = FBLab()
    let timeview = UIView()
    
    let addr_lab  = UILabel()
    let time_lab  = UILabel()
    

    
    override func onSetup() {
        super.onSetup()
        timeview.addSubviews([timePrefix, timeSubfix])
        timePrefix.frame = CGRect(x: 0, y: 0, width: fixDevice(40), height: 24)
        timePrefix.cornerRadius = 4
        timePrefix.set("打卡", font: .medium(12), color: .white)
        timePrefix.fetch(.label)
        timePrefix.set(backgournd: .theme)
        
        timeSubfix.frame = CGRect(x: timePrefix.frame.maxX, y: 0, width: fixDevice(53), height: 24)
        timeSubfix.set("\(date.string(withFormat: "HH:mm"))", font: .medium(12), color: .theme)
        timeSubfix.fetch(.label)
        
        timeview.backgroundColor = .white
        timeview.cornerRadius = 4
        
        addr_lab.set("厦门海滨路66号惠中科技大厦", .regular(10), color: .white, numberOfLines: 2)
        
        time_lab.set("时间: \(date.string(withFormat: "yyyy-MM-dd"))", .regular(10), color: .white)
        
        let array = [timeview, addr_lab, time_lab]
        stcakView.addArrangedSubviews(array)

        array.forEach { lab in
            if lab == timeview {
                lab.snp.makeConstraints { make in
                    make.left.equalTo(fixDevice(5))
                    make.height.equalTo(24)
                    make.width.equalTo(fixDevice(93))
                }
            } else {
                lab.snp.makeConstraints { make in
                    make.left.equalTo(fixDevice(5))
                    make.width.equalTo(fixDevice(132 - 10))
                }
            }

        }
    }
    
    override func config(_ rows:[MarkModel.Row]) {
        super.config(rows)
        stcakView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stcakView.removeArrangedSubviews()
        var array:[UIView] = [timeview]
        timeSubfix.set("\(date.string(withFormat: "HH:mm"))")

        
        if rows[0].isSelected {
            array.append(addr_lab)
            addr_lab.text = rows[0].detail
        }
        
        if rows[1].isSelected {
            array.append(time_lab)
            time_lab.text = "时间: \(date.string(withFormat: "yyyy-MM-dd"))"
        }
        
        stcakView.addArrangedSubviews(array)
        timeview.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(fixDevice(93))
        }
        
    }
    
}
