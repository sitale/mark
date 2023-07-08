//
//  Cards.swift
//  Mark
//
//  Created by jyck on 2023/6/26.
//

import UIKit
import CoreLocation

class CardList : FBVC , UICollectionViewDelegate,UICollectionViewDataSource  {
    
    fileprivate var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate lazy var collectionview:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    

    var onSelectedMark: ((MarkModel.Style) -> Void )?
    
    var rows:[FBRow] = MarkModel.Style.allCases.map({ FBRow(style: $0) })
    var onTapDone: ((MarkModel.Style)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarWhiteBackBtn("选择水印")
        view.backgroundColor = .white
        view.addSubview(collectionview)
        collectionview.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        collectionview.backgroundColor = .clear
        collectionview.bounces = false
        collectionview.dataSource = self
        collectionview.delegate = self
//        collectionview.isPagingEnabled = true
        collectionview.register(cellWithClass: CCell.self)
        self.view.addSubview(collectionview)
        collectionview.backgroundColor = .clear
        collectionview.showsHorizontalScrollIndicator = false
        
        
        layout.itemSize = CGSize(width: (k_window_width - 60) / 2.0, height: 136)
        layout.minimumLineSpacing = 20 - 0.1
        layout.minimumInteritemSpacing = 20 - 0.1
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        
        rows[0].model = Card1(markstyle: rows[0].markstyle)
        rows[1].model = Card2(markstyle: rows[1].markstyle)
        rows[2].model = Card3(markstyle: rows[2].markstyle)
        rows[3].model = Card4(markstyle: rows[3].markstyle)
        rows[4].model = Card5(markstyle: rows[4].markstyle)
        rows[5].model = Card6(markstyle: rows[5].markstyle)
        rows[6].model = Card7(markstyle: rows[6].markstyle)
        rows[7].model = Card8(markstyle: rows[7].markstyle)
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CCell.self, for: indexPath)
//        cell.config(vm: rows[indexPath.item])
        cell.row = rows[indexPath.item]
        let style = rows[indexPath.item].markstyle
        cell.editBtn.onTap = { [weak self] in
            guard let self else { return }
            let vc = EditView(style: style)
            vc.onTapDone = { [weak self] in
                self?.onTapDone?(style)
                self?.navigationController?.popViewController(animated: true)
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard !rows[indexPath.item].isSelected else { return }
        rows.forEach({ $0.isSelected = false })
        rows[indexPath.item].isSelected = true
    }

    
    class CCell : FBBaseCCell {
        
        let editBtn = FBLab()
        let maskColorView = UIView()
        var cardView:CardView?
        let titleLab = UILabel()
        
        override func setupSubviews() {
            backgroundColor = UIColor(0x636870)
            cornerRadius = 4
            borderWidth = 4.0
            
            contentView.addSubviews([ titleLab, maskColorView, editBtn])
            maskColorView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            maskColorView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            editBtn.cornerRadius = 8
            editBtn.set(backgournd: .theme)
            editBtn.fetch(.centerImgLab(size: 14, spacing: 6))
            editBtn.set("编辑", font: .regular(14), color: .white, icon: UIImage(named: "Frame3"))
            editBtn.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(84)
                make.height.equalTo(34)
            }
//            editBtn.onTap = { [weak self] in
//                self?.onTap()
//            }
            
            titleLab.textColor = .white
            titleLab.font = .medium(12)
            titleLab.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-10)
            }
        }
        
        
        deinit {
            print("\(self) deinit")
        }

        
        override func onFetchViews() {
            let style =  row.markstyle
            cardView?.removeFromSuperview()
            titleLab.text = style.title
            
            if let cardView = row.model as? CardView {
                cardView.removeFromSuperview()
                contentView.addSubview(cardView)
                contentView.insertSubview(cardView, belowSubview: maskColorView)
                cardView.snp.makeConstraints {
                    $0.left.equalTo(12)
                    $0.bottom.equalTo(-32)
                    $0.top.equalTo(10)
                }
                self.cardView = cardView
            }
        }
        
        override func onSelectedAction() {
            borderColor = row.isSelected ? UIColor(0x64CCE1) : UIColor.clear
            maskColorView.alpha = row.isSelected ? 1 : 0
            editBtn.alpha = row.isSelected ? 1 : 0
        }
        
        
    }
}


//
//enum Content {
//    case lat(String), long(String), address(String)
//    case mark, time(Date), loc(String),
//
//}


class MarkModel  {
    static let shared = MarkModel()
    
    var location: CLLocation?
    var inputAddress = ""
    var pickerDate: Date = Date()
    
    
    
    class Row {
        var title: String = ""
        var detail: String = ""
        var placeholder: String = ""
        var input: String = ""
        var isSelected: Bool = true
        var onFetchLocation: FBCallback?
        var isInput: Bool = false
        var isPickerData: Bool = false
        
        init(title: String, detail: String, placeholder: String = "", input: String = "", isSelected: Bool = true, isInput: Bool = false, isPickerData: Bool = false , onFetchLocation: FBCallback? = nil) {
            self.title = title
            self.detail = detail
            self.placeholder = placeholder
            self.input = input
            self.isSelected = isSelected
            self.onFetchLocation = onFetchLocation
            self.isPickerData = isPickerData
            self.isInput = isInput
        }
    }
    
    enum Style : CaseIterable {
        ///
        case geo
        case today
        case location
        case sell
        case photo
        case meetting
        case mark
        case xunjian
        
        var title: String {
            switch self {
            case .geo: return "经纬度水印"
            case .today: return "今日打卡水印"
            case .location: return "时间地点水印"
            case .sell: return "销售水印"
            case .photo:  return "时间地点水印"
            case .meetting: return "会议记录"
            case .mark:  return "打卡水印"
            case .xunjian: return "日常巡检水印"
                
            }
        }
        
        
        var rows:[Row] {
            switch self {
            case .geo: return [
                Row(title: "经度", detail: "", onFetchLocation: {
                    
                }),
                Row(title: "纬度", detail: "", onFetchLocation: {
                    
                }),
                Row(title: "地址", detail: "", placeholder: "请输入地址", isInput: true, onFetchLocation: nil),
                Row(title: "日期", detail: "", isPickerData: true, onFetchLocation: {
                    
                }),
            ]
                
            case .today: return [
                Row(title: "地点", detail: "", placeholder: "请输入地点", isInput: true, onFetchLocation: nil),
                Row(title: "时间", detail: "", isPickerData: true, onFetchLocation: {
                    
                }),
            ]
            case .location: return [
                Row(title: "时间", detail: "", isPickerData: true, onFetchLocation: {
                    
                }),
                Row(title: "地点", detail: "", placeholder: "请输入地点", isInput: true, onFetchLocation: nil),
            ]
            case .sell: return [
                Row(title: "联系方式", detail: "", placeholder: "请输入联系方式", isInput: true, onFetchLocation: nil),
                Row(title: "地址", detail: "", placeholder: "请输入地址", isInput: true, onFetchLocation: nil),
            ]
            case .photo:  return [
                Row(title: "地点", detail: "", placeholder: "请输入地点", isInput: true, onFetchLocation: nil),
                Row(title: "时间", detail: "", isPickerData: true, onFetchLocation: {
                    
                }),
            ]
            case .meetting: return [
                Row(title: "会议人数", detail: "", placeholder: "请输入会议人数", isInput: true, onFetchLocation: nil),
                Row(title: "会议内容", detail: "", placeholder: "请输入会议内容", isInput: true, onFetchLocation: nil),
                Row(title: "会议地点", detail: "", placeholder: "请输入会议地点", isInput: true, onFetchLocation: nil),
            ]
            case .mark:  return [
                Row(title: "时间", detail: "", isPickerData: true, onFetchLocation: {
                    
                }),
                Row(title: "地点", detail: "", placeholder: "请输入地点", isInput: true, onFetchLocation: nil),
            ]
            case .xunjian: return [
                Row(title: "巡检人员", detail: "", placeholder: "请输入巡检人员", isInput: true, onFetchLocation: nil),
                Row(title: "巡检内容", detail: "", placeholder: "请输入巡检内容", isInput: true, onFetchLocation: nil),
                Row(title: "巡检地点", detail: "", placeholder: "请输入巡检地点", isInput: true, onFetchLocation: nil),
            ]
                
            }
        }
        
        
        var cradView: CardView {
            switch self {
            case .geo:      return Card1(markstyle: self)
            case .today:    return Card2(markstyle: self)
            case .location: return Card3(markstyle: self)
            case .sell:     return Card4(markstyle: self)
            case .photo:    return Card5(markstyle: self)
            case .meetting: return Card6(markstyle: self)
            case .mark:     return Card7(markstyle: self)
            case .xunjian:  return Card8(markstyle: self)
            }
        }
        
        
    }
    
}














