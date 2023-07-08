//
//  FBSection.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit

public class FBSection  : Equatable, Then {
    
    public static func == (lhs: FBSection, rhs: FBSection) -> Bool {
        return Unmanaged.passUnretained(lhs).toOpaque() == Unmanaged.passUnretained(rhs).toOpaque()
    }
    
    public enum SectionType {
        case headerSepearator, footerSepearator
        case empty, none, title, insets, insetZero
        case date
        case header1, header2, header3, header4, header5
        case sk_0, sk_1, sk_2, sk_3
    }
    
    
    public var header:Any?
    public var footer:Any?
    public var model: Any?
    
    public var onTapAction: FBCallback?
    public var onTapIntAction: FBIntBlock?
    public var onTap1Action: FBCallback?
    public var onTap2Action: FBCallback?
    public var onTapArrAction:FBArrBlock?
    

    public var onTapIDAction: FBStringBlock?
    
    // 扩展数据字段
    public var ext:Any?
    // 备用扩展数据字段
    public var ext_01:Any?
    // 备用扩展数据字段
    public var ext_02:Any?
    // 备用扩展数据字段
    public var ext_03:Any?
    
    public var rows:[FBRow] = []
    public var allRows:[FBRow] = []

    public var type: SectionType
    /// 用来排序
    public var sort:Int = 0
    public var chapter:Int = 0
    
    public var tag:Int = 0
    
    public var reloadSectionBlock:FBCallback?
    /// 当前分组是否允许选择
    public var isEnableSelect:Bool = true
    /// 当前组选择回调
    public var onSelectedHandler:FBBoolBlock?
    public var isSelected: Bool = false { didSet { onSelectedHandler?(isSelected) }}
    
    /// 编辑状态回调
    public var onEditStatusHandler:FBBoolBlock?
    /// 当前组是否允许编辑
    public var isEditting:Bool = false { didSet { onEditStatusHandler?(isEditting) }}
    
    /// 刷新Header回调
    public var onFetchHeaderHandler:FBCallback?
    /// 刷新Footer回调
    public var onFetchSectionHandler:FBCallback?
    
    public var filter:String = ""
    
    public var isFlod: Bool = false
    
    public var backgroundColor: UIColor?

    
    public init(type: SectionType) {
        self.type = type
    }
    
    public init(type: SectionType, items: [FBRow] = [],
                header: Any? = nil,
                footer: Any? = nil,
                ext:Any? = nil,
                ext_01: Any? = nil,
                ext_02: Any? = nil,
                ext_03: Any? = nil,
                sort: Int = 0,
                filter: String = ""
    ) {
        self.type = type
        self.rows = items
        self.header = header
        self.footer = footer
        self.ext = ext
        self.sort = sort
        self.filter = filter
        self.ext_01 = ext_01
        self.ext_02 = ext_02
        self.ext_03 = ext_03
    }

    
    
}
