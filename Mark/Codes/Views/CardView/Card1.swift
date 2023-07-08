//
//  Card1.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

class Card1 : CardView {
    
    
    let lati_lab  = UILabel()
    let long_lab  = UILabel()
    let addr_lab  = UILabel()
    let time_lab  = UILabel()
    
    override func onSetup() {
        super.onSetup()
        stcakView.alignment = .leading
        stcakView.distribution = .equalSpacing
        
        lati_lab.set("精度: 116.3000685", .regular(10), color: .white)
        long_lab.set("精度: 39.9827735", .regular(10), color: .white)
        
        addr_lab.set("地址: 厦门海滨路66号惠中科 技大厦", .regular(10), color: .white, numberOfLines: 2)
        
        time_lab.set("时间: \(date.string(withFormat: "yyyy-MM-dd HH:mm"))", .regular(10), color: .white)
        let array = [lati_lab, long_lab, addr_lab, time_lab]
        stcakView.addArrangedSubviews(array)
        array.forEach { lab in
            lab.snp.makeConstraints { make in
                make.width.equalTo(fixDevice(132))
            }
        }
    }
    
    override func config(_ rows:[MarkModel.Row]) {
        super.config(rows)
        stcakView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stcakView.removeArrangedSubviews()
        var array:[UIView] = []
        if rows[0].isSelected {
            array.append(lati_lab)
        }
        if rows[1].isSelected {
            array.append(long_lab)
        }
        if rows[2].isSelected {
            array.append(addr_lab)
            addr_lab.text = "地址: \(rows[2].detail)"
        }
        if rows[3].isSelected {
            array.append(time_lab)
            time_lab.text = "时间: \(date.string(withFormat: "yyyy-MM-dd HH:mm"))"
        }
        stcakView.addArrangedSubviews(array)
    }
    
    override func onDidUpdateLocations() {
        lati_lab.set("精度: \(FBShared.shared.latitude.rounded(numberOfDecimalPlaces: 5, rule: .toNearestOrAwayFromZero))", .regular(10), color: .white)
        long_lab.set("精度: \(FBShared.shared.longitude.rounded(numberOfDecimalPlaces: 5, rule: .toNearestOrAwayFromZero))", .regular(10), color: .white)
    }
    
}
