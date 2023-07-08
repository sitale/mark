//
//  FBRow.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//


import UIKit

final public class FBRow :Equatable, Then {
    public static func == (lhs: FBRow, rhs: FBRow) -> Bool {
        return Unmanaged.passUnretained(lhs).toOpaque() == Unmanaged.passUnretained(rhs).toOpaque()
    }
    
    public enum RowType {
        case title, none
        case row, row1 , row2 , row3 , row4 , row5 , row6 , row7 , row8 , row9 , row10
        case sk_0, sk_1, sk_2, sk_3, sk_4, sk_5
    }
    
    // 数据存储
    public var type: RowType
    public var model: Any?
    public var ext: Any?
    public var ext_01: Any?
    public var ext_02: Any?
    public var ext_03: Any?

    // 临时引用cell内部控件，方便外部访问
    public weak var external_view: UIView?
    
    public unowned var section:FBSection?
    
    public var list:[FBRow] = []
    public weak var last:FBRow?
    public weak var next:FBRow?
    
    public var backgroundColor: UIColor?
    
    public var sort:Int = 0
    public var tag:Int = 0
    
    public var onEnableStatusHandler:FBBoolBlock?
    public var isEnable:Bool = false { didSet {
        DispatchQueue.main.async {
            self.onEnableStatusHandler?(self.isEnable)
        }
    }}
    
    public var onSelectedHandler:FBBoolBlock?
    public var isSelectedAble: Bool = false { didSet {
        DispatchQueue.main.async {
            self.onSelectedHandler?(self.isSelected)
        }
    }}
    public var isSelected: Bool = false { didSet {
        DispatchQueue.main.async {
            self.onSelectedHandler?(self.isSelected)
        }
    }}
    
    public var onEditStatusHandler:FBBoolBlock?     //编辑状态回调
    public var isEditting:Bool = false { didSet {
        DispatchQueue.main.async {
            self.onEditStatusHandler?(self.isEditting)
        }
    }}
    
    public var isEnableSwipeActions:Bool = false
    
    public var selectedIdx: Int = 0
    public var arrayIndex: FBCellPostion = .middle
    
    public var enableAddCorners = true
    public var roundingCorners: UIRectCorner?

    //需刷新数据
    public var onShouldUpdateViewStatus: FBCallback?

    public var onShouldReloadRow: FBCallback?
    
    public var onFetchTime: FBCallback?
    /// 用于快速查找对应模型的字段
    public var filterKey: String = ""
    
    public var willDisplay:Bool = false

    
    public var onSwipeAction: FBCallback?
    public var onTapAction: FBCallback?
    public var onTapIDAction: FBStringBlock?
    public var onTapBoolAction: FBBoolBlock?
    public var onTapIntAction:FBIntBlock?
    public var onTap1Action: FBCallback?
    public var onTap2Action: FBCallback?
    
    public var onTapRowAction: ((FBRow) -> Void)?
    
    
    // 用于预设cell大小
    public var adjustContentSize:CGSize = .zero
    /*
    /// tableView侧滑操作按钮
    var tableviewEditActions:[LYSideslipCellAction] = []
    
    /// 左滑是否可以操作
    var canSideslipRowAt:Bool = false
    */
    public init(type: RowType) {
        self.type = type
    }
    
    public convenience init(type: RowType, model: Any? = nil, ext: Any? = nil, ext_01: Any? = nil, ext_02: Any? = nil, sort: Int = 0, filterKey: String = "",  isSelected: Bool = false) {
        self.init(type: type)
        self.model = model
        self.sort = sort
        self.filterKey = filterKey
        self.ext = ext
        self.ext_01 = ext_01
        self.ext_02 = ext_02
        self.isSelected = isSelected
    }
    
    public convenience init(type: RowType, model: Any? = nil, isSelected: Bool = false) {
        self.init(type: type)
        self.model = model
        self.isSelected = isSelected
    }
    
    
    var markstyle: MarkModel.Style = .mark
    
    
    convenience init(style: MarkModel.Style) {
        self.init(type: .row)
        self.markstyle = style
        self.model = style
    }
    

}



