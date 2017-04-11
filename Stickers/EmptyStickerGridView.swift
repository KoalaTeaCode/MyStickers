//
//  EmptyStickerGridView.swift
//  Stickers
//
//  Created by Craig Holliday on 4/9/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import SwifterSwift
import RealmSwift

class EmptyStickerGridView: UIView {
    var contentView = UIView()
    var stackView = UIStackView()
    
    var label = LabelWithAdaptiveTextHeight()
    var imageView = UIImageView()
    var textLabel = LabelWithAdaptiveTextHeight()
    var button = UIButton()
    
    var fromViewController: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        return;
    }
    
    init(frame: CGRect, fromViewController: UIViewController) {
        super.init(frame: frame)
        self.fromViewController = fromViewController
        self.performLayout()
    }
    
    override func layoutSubviews() {
        Stylesheet.applyOn(self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        let width = self.width / 1.5
        
        self.addSubview(contentView)
        self.contentView.addSubview(stackView)
        self.imageView.addSubview(label)
        self.stackView.addArrangedSubview(imageView)
        self.stackView.addArrangedSubview(textLabel)
        self.stackView.addArrangedSubview(button)
        
        var inset = 0
        
        if let navBar = fromViewController.navigationController?.navigationBar {
            inset = Int(navBar.height)
        }
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().dividedBy(2.5)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(-(inset * 2))
        }
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.stackView.axis = .vertical
        self.stackView.distribution = .equalSpacing
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let size = CGSize(width: width, height: width / 2)
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(size)
        }

        self.label.textAlignment = .center
        self.label.adjustsFontSizeToFitWidth = true
        self.label.baselineAdjustment = .alignCenters
        
        label.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.textLabel.textAlignment = .center
        self.textLabel.adjustsFontSizeToFitWidth = true
        self.textLabel.baselineAdjustment = .alignCenters
        
        self.button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
    }
    
    func buttonPressed() {
        let vc = CanvasViewController()
        let navVc = UINavigationController(rootViewController: vc)
        
        fromViewController.navigationController?.present(navVc, animated: true, completion: nil)
    }
}
