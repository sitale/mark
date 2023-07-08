//
//  Card6.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import Foundation

class Card6 : CardView {
    
    
    let time_lab = UILabel()
    let week_lab = UILabel()
    let hour_lab = UILabel()
    let time_con = UIView()
    
    let meet_num_lab = UILabel()
    let meet_cnt_lab = UILabel()
    let meet_add_lab = UILabel()
    let weeks = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    
    override func onSetup() {
        super.onSetup()

        time_lab.set(date.string(withFormat: "HH:mm"), .medium(30), color: .white)
        week_lab.set(weeks[date.weekday - 1], .regular(10), color: .white)
        hour_lab.set(date.string(withFormat: "yyyy/MM/dd"), .regular(10), color: .white)
        
        time_con.addSubviews([time_lab, week_lab, hour_lab])
        time_lab.frame  = CGRect(x: 0, y: 0, width: 81, height: 42)
        time_lab.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        week_lab.snp.makeConstraints { make in
            make.left.equalTo(time_lab.snp.right).offset(6)
            make.top.equalTo(5)
        }
        hour_lab.snp.makeConstraints { make in
            make.left.equalTo(time_lab.snp.right).offset(6)
            make.top.equalTo(23)
        }
        
//        hour_lab.frame  = CGRect(x: time_lab.frame.maxX , y: 23, width: 60, height: 16)
        
        meet_num_lab.set("会议人数：3", .regular(10), color: .white)
        meet_cnt_lab.set("会议内容：会议内容内容内容", .regular(10), color: .white)
        meet_add_lab.set("会议地点：A1会议室", .regular(10), color: .white)
        
        stcakView.addArrangedSubviews([time_con, meet_num_lab, meet_cnt_lab, meet_add_lab])
        time_con.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(42)
        }
        meet_num_lab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(fixDevice(132))
        }
        meet_cnt_lab.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(fixDevice(132))
        }
        meet_add_lab.snp.makeConstraints { make in
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
        var array:[UIView] = [time_con]
        
        time_lab.text = date.string(withFormat: "HH:mm")
        week_lab.text = weeks[date.weekday - 1]
        hour_lab.text = date.string(withFormat: "yyyy/MM/dd")
        
        if rows[0].isSelected {
            array.append(meet_num_lab)
            meet_num_lab.text = "会议人数: \(rows[0].detail)"
        }
        
        if rows[1].isSelected {
            array.append(meet_cnt_lab)
            meet_cnt_lab.text = "会议内容: \(rows[1].detail)"
        }
        
        if rows[2].isSelected {
            array.append(meet_add_lab)
            meet_add_lab.text = "会议地点: \(rows[2].detail)"
        }
        
        stcakView.addArrangedSubviews(array)
        
        time_con.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(42)
        }
        if rows[0].isSelected {
            meet_num_lab.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(fixDevice(132))
            }
        }
        if rows[1].isSelected {
            meet_cnt_lab.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(fixDevice(132))
            }
        }
        if rows[2].isSelected {
            meet_add_lab.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.width.equalTo(fixDevice(132))
            }
        }


    }
    
}
