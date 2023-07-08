//
//  Card7.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import Foundation

class Card7 : CardView {
    
    let timePrefix = FBLab()
    let timeSubfix = FBLab()
    let timeview = UIView()
    
    let addr_lab  = UILabel()
    let time_lab  = UILabel()
    
    override func onSetup() {
        super.onSetup()
        timeview.addSubviews([timePrefix, timeSubfix])
        timePrefix.frame = CGRect(x: 0, y: 0, width: fixDevice(84), height: 25)
        timePrefix.set("打卡记录", font: .medium(12), color: .white)
        timePrefix.fetch(.label)
        timePrefix.set(backgournd: .theme)
        
        timeSubfix.frame = CGRect(x: 0, y: timePrefix.frame.maxY, width: fixDevice(84), height: 36)
        timeSubfix.set("\(date.string(withFormat: "HH:mm"))", font: .medium(24), color: .black)
        timeSubfix.fetch(.label)
        
        timeview.backgroundColor = .white
        timeview.cornerRadius = 12
      
        
        time_lab.set("", .regular(10), color: .white, alignment: .center)
        addr_lab.set("xxx市·XXXXXX", .regular(10), color: .white, alignment: .center, numberOfLines: 2)
 
        stcakView.alignment = .center
        let array = [timeview, time_lab , addr_lab ]
        stcakView.addArrangedSubviews(array)

        array.forEach { lab in
            if lab == timeview {
                lab.snp.makeConstraints { make in
                    make.height.equalTo(61)
                    make.width.equalTo(fixDevice(84))
                }
            } else {
                lab.snp.makeConstraints { make in
                    make.width.equalTo(fixDevice(132 - 10))
                }
            }

        }
    }
    
    override func onDidUpdateLocations() {
        timeSubfix.set("\(date.string(withFormat: "HH:mm"))")
        let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        time_lab.text = "\(date.string(withFormat: "yyyy.MM.dd \(weeks[date.weekday - 1])")) "

    }
    
    override func config(_ rows:[MarkModel.Row]) {
        super.config(rows)
        stcakView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        stcakView.removeArrangedSubviews()
        var array:[UIView] = [timeview]
        timeview.snp.remakeConstraints { make in
            make.height.equalTo(61)
            make.width.equalTo(fixDevice(84))
        }
        onDidUpdateLocations()
        
        
        if rows[0].isSelected {
            array.append(time_lab)
        }
        
        if rows[1].isSelected {
            array.append(addr_lab)
        }

        
        stcakView.addArrangedSubviews(array)

        if rows[0].isSelected {
            time_lab.snp.remakeConstraints { make in
                make.width.equalTo(fixDevice(132 - 10))
            }
        }
        
        if rows[1].isSelected {
            addr_lab.snp.remakeConstraints { make in
                make.width.equalTo(fixDevice(132 - 10))
            }
        }

    }
    
}
