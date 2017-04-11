//
//  ControlsView.swift
//  Stickers
//
//  Created by Craig Holliday on 3/26/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import SwifterSwift
import RealmSwift
//import Reusable
import KoalaTeaFlowLayout

class ControlsView: UIView {
    
    var widthSlider = UISlider()
    var widthLabel = UILabel()
    var alphaSlider = UISlider()
    var alphaLabel = UILabel()
    var bottomView = UIView()
    
    var fromViewController: UIViewController!
    
    var currentBrush: DefaultBrush! = { return DefaultBrush.getActive() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.performLayout()
        return;
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func performLayout() {
        self.backgroundColor = .white
        
        self.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setupWidthSlider()
        setupAlphaSlider()
    }
    
    func setupWidthSlider() {
        bottomView.addSubview(widthSlider)
        bottomView.addSubview(widthLabel)
        
        widthSlider.isContinuous = true
        widthSlider.minimumValue = 1
        widthSlider.maximumValue = 128
        widthSlider.setValue(Float(currentBrush.getWidth()), animated: false)
        widthSlider.addTarget(self, action: #selector(self.widthSliderValueDidChange(_:)), for: .valueChanged)
        
        widthLabel.text = formatFloatFor(width: widthSlider.value)
        
        widthLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
        }

        widthSlider.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(widthLabel.snp.bottom).inset(-5)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(4)
        }
    }
    
    func setupAlphaSlider() {
        bottomView.addSubview(alphaSlider)
        bottomView.addSubview(alphaLabel)
        
        alphaSlider.isContinuous = true
        alphaSlider.minimumValue = 0.01
        alphaSlider.maximumValue = 1
        alphaSlider.setValue(Float(currentBrush.getAlpha()), animated: false)
        alphaSlider.addTarget(self, action: #selector(self.alphaSliderValueDidChange(_:)), for: .valueChanged)
        
        alphaLabel.text = formatFloatFor(alpha: alphaSlider.value)
        
        alphaLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(widthSlider.snp.bottom).inset(-5)
            make.left.equalToSuperview().inset(10)
        }
        
        alphaSlider.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(alphaLabel.snp.bottom).inset(-5)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(4)
        }
    }
    
    func widthSliderValueDidChange(_ sender: UISlider!)
    {
        widthLabel.text = formatFloatFor(width: sender.value)
        
        currentBrush.update(brushWidth: sender.value)
    }
    
    func alphaSliderValueDidChange(_ sender: UISlider!)
    {
        alphaLabel.text = formatFloatFor(alpha: sender.value)
        
        currentBrush.update(brushAlpha: sender.value)
    }
    
    func formatFloatFor(width: Float) -> String {
        let formattedFloat = round(width).cleanValue
        return L10n.brushWidth + " : " + String(formattedFloat)
    }
    
    func formatFloatFor(alpha: Float) -> String {
        let formattedFloat = round(alpha * 100).cleanValue
        return L10n.brushAlpha + " : " + String(formattedFloat) + "%"
    }
}

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
