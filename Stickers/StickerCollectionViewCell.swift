//
//  CollectionViewCell.swift
//  Stickers
//
//  Created by Craig Holliday on 3/27/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Messages
import SnapKit
import Reusable

class StickerCollectionViewCell: UICollectionViewCell, Reusable {
    var topView = UIView()
    var bottomView = UIView()
    var stickerView = MSStickerView(frame: .zero, sticker: nil)
    var imageView = UIImageView()
    
    var cellLabel = LabelWithAdaptiveTextHeight()
    var imageTintColor = UIColor(hex: 0x262626)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        performLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override func layoutSubviews() {
        Stylesheet.applyOn(self)
    }
    
    func performLayout() {
        self.addSubview(topView)
        self.addSubview(bottomView)
        
        topView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(1.25)
        }
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setupStickerView()
        setupImageView()
        setupLabel()
    }
    
    func setupStickerView() {
        self.topView.addSubview(stickerView)
        stickerView.isUserInteractionEnabled = true
        
        stickerView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self.topView.snp.size)
        }
    }
    
    func setupImageView() {
        self.topView.addSubview(imageView)
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self.topView.snp.size)
        }
    }
    
    func setupLabel() {
        self.bottomView.addSubview(cellLabel)
        self.cellLabel.textAlignment = .center
        self.cellLabel.adjustsFontSizeToFitWidth = true
        self.cellLabel.baselineAdjustment = .alignCenters
        self.cellLabel.numberOfLines = 1
        
        cellLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(stickerModel: StickerModel, isExtension: Bool) {
        switch isExtension {
        case true:
            self.configureExtensionCell(stickerModel: stickerModel)
        default:
            self.configureAppCell(stickerModel: stickerModel)        }
        
    }
    
    func configureExtensionCell(stickerModel: StickerModel) {
        imageView.isHidden = true
        stickerView.isHidden = false
        
        guard let sticker = stickerModel.getSticker() else {
            log.error("Sticker couldn't load")
            return
        }

        self.stickerView.sticker = sticker
        
        guard let name = stickerModel.getName() else {
            log.error("Sticker has no name")
            return
        }
        
        self.cellLabel.text = name
    }
    
    func configureAppCell(stickerModel: StickerModel) {
        imageView.isHidden = false
        stickerView.isHidden = true
        //@TODO: Use imageview when not in messextenions
        
        guard let localImagePath = stickerModel.getLocalImageURL()?.path else {
            log.error("Sticker couldn't load")
            return
        }
        
        let image = UIImage(contentsOfFile: localImagePath)
        imageView.image = image
        
        guard let name = stickerModel.getName() else {
            log.error("Sticker has no name")
            return
        }
        
        self.cellLabel.text = name
    }
    
    func configureAddCell() {
        imageView.isHidden = false
        stickerView.isHidden = true
        
        imageView.setIcon(icon: .fontAwesome(.plus), textColor: imageTintColor, backgroundColor: .clear, size: self.size)
        
        self.cellLabel.text = "Add"
    }
}
