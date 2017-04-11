//
//  HeaderCollectionReusableView.swift
//  Stickers
//
//  Created by Craig Holliday on 4/10/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class HeaderCollectionReusableView: UICollectionReusableView, Reusable {
    
    var fromViewController: UIViewController!
    
    var topBarViewLabel = LabelWithAdaptiveTextHeight()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        Stylesheet.applyOn(self)
        return;
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.addSubview(topBarViewLabel)
        
        topBarViewLabel.snp.makeConstraints { (make) -> Void in
            let inset = 2.5
            make.top.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
        
}
