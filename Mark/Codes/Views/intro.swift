//
//  intro.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import UIKit
import SwifterSwift

class Intro : FBVC , UICollectionViewDelegate,UICollectionViewDataSource  {
    
    
    fileprivate var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate lazy var collectionview:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    fileprivate let enterBtn = FBLab(frame: .zero)
    fileprivate var data:[RowModel] = []
    var actionHandler: FBCallback?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navBar.isHidden = true
        
        let imageView = UIImageView(view.bounds, image: UIImage(named: "bg"), superview: self.view)
        
        
        
        modalTransitionStyle = .coverVertical
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        layout.itemSize = CGSize(width: view.bounds.width, height:  view.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        
        collectionview = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionview.bounces = false

        
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true
        collectionview.register(cellWithClass: CCell.self)
        self.view.addSubview(collectionview)
        collectionview.backgroundColor = .clear
        collectionview.showsHorizontalScrollIndicator = false

        data = [RowModel(title: "高清水印拍照", detail: "智能地点，时间等实时 显示", content: UIImage(named:  "Mask group 2")),
                RowModel(title: "超多水印模板", detail: "智能地点，时间等实时 显示", content: UIImage(named:  "Mask group 1")),
                RowModel(title: "自定义水印内容", detail: "水印信息完全自定义", content: UIImage(named:  "Mask group")),
        ]
        
        collectionview.reloadData()


        
        self.view.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalTo(180)
            make.bottom.equalTo( -10  - k_safe_tabbar_bottom)
        }
        
        enterBtn.onTap = { [weak self] in
            self?.onTapActionHandler()
        }
        
        enterBtn.fetch(.label)
        enterBtn.set("继续", font: .medium(16), color: .white)
        enterBtn.backgroundColor = .theme
        enterBtn.cornerRadius = 12
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CCell.self, for: indexPath)
        cell.config(vm: data[indexPath.item])
        return cell
    }
    
    
    @objc fileprivate func onTapActionHandler() {
        if enterBtn.isSelected {
            actionHandler?()
        } else {
            let page: Int = Int(collectionview.contentOffset.x / collectionview.bounds.size.width)
            self.collectionview.setContentOffset(CGPoint(x: CGFloat(page + 1) * collectionview.bounds.size.width, y: 0), animated: true)
        }
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.enterBtn.isSelected = page == self.data.count - 1
//        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
//            self.enterBtn.alpha = page == self.data.count - 1 ? 1 : 0
//        }
    }
    
    
    struct RowModel {
        let title: String
        let detail: String
        let content: UIImage?
    }
    
    class CCell : FBBaseCCell {
        let imageView = UIImageView()
        let titleLab = UILabel()
        let detailLabl = UILabel()
        
        override func setupSubviews() {
            super.setupSubviews()
            backgroundColor = .clear
            addSubviews([imageView , titleLab, detailLabl])
            imageView.contentMode = .scaleToFill

            
            imageView.contentMode = .scaleToFill
            imageView.snp.makeConstraints { make in
                make.top.equalTo(k_status_bar_height + fixDevice(58))
                make.centerX.equalToSuperview()
                make.width.equalTo(fixDevice(340))
                make.height.equalTo(fixDevice(548))
            }
            
            titleLab.font = .medium(24)
            titleLab.textColor = .title
            titleLab.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).offset(5)
            }
            
            detailLabl.font = .medium(16)
            detailLabl.textColor = .detail
            detailLabl.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLab.snp.bottom).offset(8)
            }
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            contentView.removeSubviews()
        }
            
        func config(vm: RowModel) {
            self.imageView.image = vm.content
            titleLab.text = vm.title
            detailLabl.text = vm.detail
        }
            
        
        func configure( infos:[UIView] ) {
            self.contentView.addSubviews(infos)
        }
        
    }
    
    
}
