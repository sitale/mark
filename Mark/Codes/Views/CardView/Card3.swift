//
//  Card3.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit


class Card3 : CardView {
    
    let time_lab = UILabel()
    let loc_lab  = FBLab()
    let add_lab  = FBLab()
    

 
    override func onSetup() {
        super.onSetup()
        time_lab.set(date.string(withFormat: "HH:mm"), .medium(24), color: .white, alignment: .center)
        
        loc_lab.set(date.string(withFormat: "yyyy-MM-dd"), font: .regular(10), color: .white, icon: UIImage(named: "Frame4"))
        loc_lab.fetch(.imgLab(leading: 15, size: 12, spacing: 7, trailling: 0))
        
        add_lab.set(date.string(withFormat: "南山区腾讯大厦"), font: .regular(10), color: .white, icon: UIImage(named: "Frame5"))
        add_lab.fetch(.imgLab(leading: 15, size: 12, spacing: 7, trailling: 0))
        
        let array = [time_lab, loc_lab, add_lab]
        stcakView.addArrangedSubviews(array)
        time_lab.snp.makeConstraints { make in
            make.width.equalTo(fixDevice(132))
            make.height.equalTo(34)
        }
        loc_lab.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.width.equalTo(fixDevice(132))
            make.height.equalTo(16)
        }
        
        add_lab.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.width.equalTo(fixDevice(132))
            make.height.equalTo(16)
        }
    }
    
    override func config(_ rows:[MarkModel.Row]) {
        super.config(rows)
        stcakView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stcakView.removeArrangedSubviews()
        var array:[UIView] = [time_lab]
        time_lab.text = date.string(withFormat: "HH:mm")
        
        if rows[0].isSelected {
            array.append(loc_lab)
            loc_lab.set(date.string(withFormat: "yyyy-MM-dd"))
        }
        
        if rows[1].isSelected {
            array.append(add_lab)
            add_lab.set(rows[1].detail)
        }
        
        stcakView.addArrangedSubviews(array)
        time_lab.snp.remakeConstraints { make in
            make.width.equalTo(fixDevice(132))
            make.height.equalTo(34)
        }
        
        if rows[0].isSelected  {
            loc_lab.snp.remakeConstraints { make in
                make.left.equalTo(5)
                make.width.equalTo(fixDevice(132))
                make.height.equalTo(16)
            }
        }

        if rows[0].isSelected  {
            add_lab.snp.remakeConstraints { make in
                make.left.equalTo(5)
                make.width.equalTo(fixDevice(132))
                make.height.equalTo(16)
            }
        }
    }
}
