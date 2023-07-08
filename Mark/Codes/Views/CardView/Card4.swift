//
//  Card4.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

class Card4 : CardView {
    
    let title_lab = UILabel()
    let mobi_lab = UILabel()
    let addr_lab = UILabel()
    
    override func onSetup() {
        super.onSetup()
        
        title_lab.set("宣传产品", .medium(12), color: .white)
        
        mobi_lab.set("联系方式: 168xxxx8888", .regular(10), color: .white)
        
        addr_lab.set("地址：厦门海滨路66号惠中科技大厦", .regular(10), color: .white, numberOfLines: 0)
        
        let array = [title_lab, mobi_lab, addr_lab]
        stcakView.addArrangedSubviews(array)

        array.forEach { lab in
            lab.snp.makeConstraints { make in
                make.left.equalTo(2)
                make.width.equalTo(fixDevice(132 - 4))
            }
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
            array.append(mobi_lab)
            mobi_lab.text = "联系方式: \(rows[0].detail)"
        }
        
        if rows[1].isSelected {
            array.append(addr_lab)
            addr_lab.text = "地址：\(rows[1].detail)"
        }
        
        stcakView.addArrangedSubviews(array)
        stcakView.arrangedSubviews.forEach { lab in
            lab.snp.remakeConstraints { make in
                make.left.equalTo(2)
                make.width.equalTo(fixDevice(132 - 4))
            }
        }
    }
    
}

