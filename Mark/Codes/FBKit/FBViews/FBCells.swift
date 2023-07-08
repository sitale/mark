//
//  FBCells.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit



import UIKit
import CoreGraphics

//MARK: - CollectionView
//MARK: - 基础类
class FBBaseCHeader : UICollectionReusableView {
    var _bottomLine:UIView = UIView().then {
        $0.backgroundColor = .line
    }
    
//    let contentView = FBView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    @objc dynamic func setupSubviews(){
        
    }
    
    var topView: UIView? = nil
    var top: CGFloat = 0
    var lineheight: CGFloat = 0.5
    var horizontal: CGFloat = 0
    var padding:CGFloat = 0
    
    // 使用自动布局。 通过_bottomLine 的约束来确定 cell 高度
    func addBottomLine(topView: UIView? = nil, _ top: CGFloat, height: CGFloat = 0.5, horizontal: CGFloat = 0, padding: CGFloat = 10) {
        self.topView = topView
        self.top = top
        self.lineheight = height
        self.horizontal = horizontal
        self.padding = padding
//        print("\(self) addBottomLine")
        if _bottomLine.superview == nil  { addSubview(_bottomLine) }
        _bottomLine.snp.remakeConstraints { make in
            make.left.equalTo(horizontal).priority(800)
            make.width.equalTo(k_window_width - 2 * horizontal - padding)
            make.right.equalTo(-horizontal)
            if let topView = topView {
                make.top.equalTo(topView.snp.bottom).offset(top).priority(800)
            } else {
                make.top.equalTo(top).priority(800)
            }
            make.bottom.equalToSuperview()
            make.height.equalTo(lineheight)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        print("\(self) prepareForReuse")

    }
    
    
    var section:FBSection! {didSet {
        section?.onFetchHeaderHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.fetchUI()
                self?.willDisplay()
            }
        }
        fetchUI()
    }}
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attri = super.preferredLayoutAttributesFitting(layoutAttributes)
//        attri.isHidden
        return attri
    }
    
    @objc dynamic func fetchUI() {
        
    }
    
    @objc dynamic func willDisplay() {
        
    }
    
    @objc dynamic func didEndDisplaying() {
        
    }
}

public enum FBCellPostion : Int {
    case first,middle, last, onlyOne
}


class FBBaseCCell : UICollectionViewCell {
    
    lazy var _bottomLine = UIView().then {
        $0.backgroundColor = .line
    }
    
    var adjustContentSize:CGSize = .zero
   
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attri = super.preferredLayoutAttributesFitting(layoutAttributes)
        if let size = row?.adjustContentSize ,  size != .zero {
            attri.size = size
        } else if adjustContentSize != .zero {
            attri.size = adjustContentSize
        }
        return attri
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .cellColor
        setupSubviews()
    }
    
    
    @objc dynamic func setupSubviews() {}
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }


    // 用于哪些没必要复用的cell。判断标志
    var isDidFetchViews = false
    var enableSelectionStyle: Bool  { false }
    var roundingCorners: UIRectCorner?
    var isEnableCornerMask = true
    var maskFrame: CGRect?
    
    // 使用自动布局。 通过_bottomLine 的约束来确定 cell 高度
    func addBottomLine(topView: UIView? = nil, _ top: CGFloat, height: CGFloat = 0.5, horizontal: CGFloat = 0, maxMargin: CGFloat? = nil, padding: CGFloat = 10) {
        if _bottomLine.superview == nil  { contentView.addSubview(_bottomLine) }
        _bottomLine.snp.remakeConstraints { make in
            make.left.equalTo(horizontal).priority(800)
            make.width.equalTo(k_window_width - 2 * horizontal - padding)
            make.right.equalTo(-horizontal)
            if let topView = topView {
                make.top.equalTo(topView.snp.bottom).offset(top).priority(800)
            } else {
                make.top.equalTo(top).priority(800)
            }
            if let maxMargin = maxMargin {
                make.top.greaterThanOrEqualTo(maxMargin)
            }
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    
    func layoutLine(top: CGFloat, width: CGFloat, height: CGFloat = 0.5, left: CGFloat = 0,  right: CGFloat = 0, topView: UIView? = nil) {
        if _bottomLine.superview == nil  { contentView.addSubview(_bottomLine) }
        _bottomLine.snp.remakeConstraints { make in
            make.left.equalTo(left).priority(800)
            make.width.equalTo(width)
            make.right.equalTo(-right)
            if let topView = topView {
                make.top.equalTo(topView.snp.bottom).offset(top).priority(800)
            } else {
                make.top.equalTo(top).priority(800)
            }
            make.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    
    var row:FBRow! {didSet {
        row?.onSelectedHandler = { [weak self] s in
            self?.onSelectedAction()
        }
        row?.onEditStatusHandler = { [weak self] e in
            self?.onEdittingAction()
        }
        
        row?.onShouldUpdateViewStatus = { [weak self] in
            self?.onFetchViews()
            self?.willDisplay()
        }
        didSetRow()
    }}
    
    private func didSetRow() {
        onSelectedAction()
        onEdittingAction()
        onFetchViews()
        position(row.arrayIndex)
    }
    
    @objc dynamic func onSelectedAction() {
        
    }
    
    @objc dynamic func onEdittingAction() {
        
    }
    
    @objc dynamic func onFetchViews() {
        
    }
    
    @objc dynamic func willDisplay() {
        
    }
    
    @objc dynamic func didEndDisplaying() {
        
    }
    
    func position( _ pos: FBCellPostion) {
        guard isEnableCornerMask else { return }
        switch pos {
        case .first:
            _bottomLine.isHidden = false
        case .last:
            _bottomLine.isHidden = true
        case .onlyOne:
            _bottomLine.isHidden = true
        default:
            _bottomLine.isHidden = false
        }
    }
}


class HEmptyPlainHeader : FBBaseCHeader {
    
    override func setupSubviews() {
        super.setupSubviews()
        backgroundColor = .clear
        addSubview(_bottomLine)
        _bottomLine.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.1)
            $0.top.equalToSuperview().priority(800)
        }
        _bottomLine.backgroundColor = .clear
    }
    
}

final class HSepearatorCFooter : FBBaseCHeader {
    override func setupSubviews() {
        addBottomLine(5, height: 0)
    }
}

typealias HSepearatorCHeader = HSepearatorCFooter

