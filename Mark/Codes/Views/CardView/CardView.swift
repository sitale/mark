//
//  CardView.swift
//  Mark
//
//  Created by jyck on 2023/6/28.
//

import UIKit

class CardView : FBView {
    var style: MarkModel.Style = .mark
    let stcakView = UIStackView(arrangedSubviews: [], axis: .vertical, spacing: 5, alignment: .center)

    var date: Date { FBShared.shared.date }
    
    required init(markstyle: MarkModel.Style) {
        style = markstyle
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidUpdateLocations), name: .onLoadLocationNotification, object: nil)
        onDidUpdateLocations()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc dynamic func onDidUpdateLocations() {
        
    }
    
    override func onSetup() {
        addSubview(stcakView)
        stcakView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    
    func config(_ rows:[MarkModel.Row]) {
        stcakView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
