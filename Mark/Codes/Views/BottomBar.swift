//
//  BottomBar.swift
//  Mark
//
//  Created by jyck on 2023/6/26.
//

import UIKit

class BottomBar : FBView {

    let albumBtn = FBLab()
    let markBtn = FBLab()
    
    let photoBtn = FBLab()
    let videoBtn = FBLab()
    let dot = UIView()
    let takeBtn = FBLab()
    
    var isRecording: Bool { videoBtn.isSelected }
    var onChangedCallback: FBCallback?
    
    override func onSetup() {
        backgroundColor = .white
        addSubviews([photoBtn, videoBtn, dot, albumBtn, markBtn, takeBtn])
        
        dot.frame = CGRect(x: 0, y: fixDevice(36), width: 6, height: 6)
        dot.backgroundColor = .theme
        dot.cornerRadius = 3
        
        photoBtn.set("拍照", font: .regular(14), color: .detail)
        photoBtn.set(.semibold(14), for: .selected)
        photoBtn.set(.title, for: .selected)
        photoBtn.fetch(.label)
        photoBtn.frame = CGRect(x: fixDevice(114 - 55), y: fixDevice(13), width: fixDevice(28 + 110), height: fixDevice(20))
        photoBtn.onTap = onTapPhoto
        
        videoBtn.set("视频", font: .regular(14), color: .detail)
        videoBtn.set(.semibold(14), for: .selected)
        videoBtn.set(.title, for: .selected)
        videoBtn.fetch(.label)
        videoBtn.frame = CGRect(x: photoBtn.frame.maxX, y: fixDevice(13), width: fixDevice(28 + 110), height: fixDevice(20))
        videoBtn.onTap = onTapVideo
        
        
        
        takeBtn.frame = CGRect(x: fixDevice(152), y: fixDevice(65), width: fixDevice(72), height: fixDevice(72))
        takeBtn.fetch(.image(size: fixDevice(72)))
        takeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(fixDevice(72))
            make.top.equalTo(fixDevice(65))
            make.centerX.equalToSuperview()
        }
        
        albumBtn.fetch(.topImgLab(top: 0, size: fixDevice(48), spacing: 8, bottom: 0))
        albumBtn.set("相册", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319808"))
        albumBtn.snp.makeConstraints { make in
            make.width.equalTo(fixDevice(48))
                make.top.equalTo(fixDevice(65))
            make.left.equalTo(fixDevice(52))
        }
        
        
        markBtn.fetch(.topImgLab(top: 0, size: fixDevice(48), spacing: 8, bottom: 0))
        markBtn.set("水印", font: .regular(16), color: .title, icon: UIImage(named: "Frame 427319807"))
        markBtn.snp.makeConstraints { make in
            make.width.equalTo(fixDevice(48))
                make.top.equalTo(fixDevice(65))
            make.right.equalTo(-fixDevice(52))
//            make.centerX.equalTo(k_window_width / 4.0 * 3)
        }

        onTapPhoto()
        configTakeBtnUI()
    }
    
    
    func onTapPhoto() {
        guard !photoBtn.isSelected else { return }

        self.photoBtn.isSelected = true
        self.videoBtn.isSelected = false
        self.dot.center = CGPoint(x: self.photoBtn.center.x, y: self.dot.center.y)
        configTakeBtnUI()
        onChangedCallback?()
    }
    
    func onTapVideo() {
        guard !videoBtn.isSelected else { return }
        self.videoBtn.isSelected = true
        self.photoBtn.isSelected = false
        self.dot.center = CGPoint(x: self.videoBtn.center.x, y: self.dot.center.y)
        configTakeBtnUI()
        onChangedCallback?()
    }
    
    func configTakeBtnUI() {
        if photoBtn.isSelected {
            takeBtn.set(UIImage(named: "Frame 427319788"), for: .normal)
            takeBtn.set(UIImage(named: "Frame 427319788"), for: .selected)
        } else {
            takeBtn.set(UIImage(named: "Frame 427319790"), for: .normal)
            takeBtn.set(UIImage(named: "Frame 427319791"), for: .selected)
        }
    }
}
