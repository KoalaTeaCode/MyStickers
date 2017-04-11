//
//  Stylesheet.swift
//  Stickers
//
//  Created by Craig Holliday on 3/28/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SwifterSwift
import UIFontComplete

// MARK: - Stylesheet
enum Stylesheet {
    
    enum Colors {
        static let white = UIColor(hex: 0xFFFFFF)
        static let offBlack = UIColor(hex: 0x262626)
        static let offWhite = UIColor(hex: 0xF3F3F3)
        
        static let baseColor = UIColor(hex: 0xFFAD69)
        static let lighter1 = UIColor(hex: 0xFFC18D)
        static let lighter2 = UIColor(hex: 0xFFD8B8)
        static let darker1 = UIColor(hex: 0xE38B42)
        static let darker2 = UIColor(hex: 0xC0671E)
    }
    
    enum pureColors {
        static let white = UIColor(hex: 0xFFFFFF)
        static let black = UIColor(hex: 0x000000)
        static let yellow = UIColor(hex: 0xf1e70d)
        static let yellowOrange = UIColor(hex: 0xfdc70f)
        static let orange = UIColor(hex: 0xf28f20)
        static let orangeRed = UIColor(hex: 0xec6224)
        static let red = UIColor(hex: 0xe42426)
        static let redPurple = UIColor(hex: 0xc31a7f)
        static let purple = UIColor(hex: 0x6e398d)
        static let purpleBlue = UIColor(hex: 0x424f9b)
        static let blue = UIColor(hex: 0x2072b2)
        static let blueGreen = UIColor(hex: 0x1d96bb)
        static let green = UIColor(hex: 0x0a905d)
        static let greenYellow = UIColor(hex: 0x8cbd3f)
    }
    
    enum Fonts {
        static let Regular = "OpenSans"
        static let Bold = "OpenSans-Bold"
        static let Italic = "OpenSans-Italic"
        static let pacificoRegular = "Pacifico-Regular"
    }
    
    enum Contexts {
        enum Global {
            static let StatusBarStyle = UIStatusBarStyle.lightContent
            static let BackgroundColor = Colors.offBlack
        }
        
        enum NavigationController {
//            static let BarTintColor = Colors.ttRed
            static let BarTextColor = Colors.white
            static let BarColor = Colors.white
        }
        
        enum CanvasController {
            static let backgroundColor = Colors.offWhite
            static let canvasBackgroundColor = UIColor.clear
            static let toolBarBackgroundColor = Colors.offBlack
            static let toolBarActiveIconColor = UIColor.white
            static let toolBarDisabledIconColor = UIColor.gray
            
            static let barButtonColor = Colors.darker1
        }
        
        enum StickerGridVC {
            static let backgroundColor = Colors.white
            static let collectionViewBackgroundColor = Colors.white
            static let textColor = Colors.baseColor
        }
        
        enum StickerCell {
            static let backgroundColor = Colors.offWhite
            static let topViewBackgroundColor = Colors.offWhite
            static let textColor = Colors.offBlack
            static let imageTint = Colors.lighter1
        }
        
        enum EmptyStickerGridView {
            static let backgroundColor = Colors.white
            static let buttonColor = Colors.darker1
        }
        
        enum CollectionViewHeader {
            static let backgroundColor = Colors.white
            static let textColor = Colors.baseColor
        }
    }
    
}

// MARK: - Apply Stylesheet
extension Stylesheet {
    
//    static func applyOn(_ navVC: UINavigationController) {
//        typealias context = Contexts.NavigationController
//        navVC.navigationBar.setColors(background: context.BarTintColor, text: context.BarTextColor)
//        //        navVC.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: Fonts.Regular, size: 22.0)!, NSForegroundColorAttributeName: context.BarTextColor]
//        navVC.navigationBar.isTranslucent = false
//    }
    
    static func applyOn(_ vc: CanvasViewController) {
        typealias context = Contexts.CanvasController
        
        vc.view.backgroundColor = context.backgroundColor
        
        vc.canvasContainerView.backgroundColor = context.canvasBackgroundColor
        
        vc.toolBar.backgroundColor = context.toolBarBackgroundColor
        
        vc.iconActiveColor = context.toolBarActiveIconColor
        vc.iconDisabledColor = context.toolBarDisabledIconColor
        
        vc.saveBarButton.tintColor = context.barButtonColor
        vc.exitBarButton.tintColor = context.barButtonColor
    }
    
    static func applyOn(_ vc: StickerGridViewController) {
        typealias context = Contexts.StickerGridVC
        
        vc.titleLabel.text = "My Stickers"
        vc.titleLabel.textColor = context.textColor
        vc.titleLabel.contentMode = .center
        vc.titleLabel.customFont = UIFont(name: Fonts.pacificoRegular, size: 200)!
        vc.titleLabel.sizeToFit()
        
        if (vc.navigationController != nil) {
            vc.titleLabel.height = (vc.navigationController?.navigationBar.height)! - 5
        }
            
        vc.view.backgroundColor = context.backgroundColor
        
        vc.collectionView.backgroundColor = context.collectionViewBackgroundColor
    }
    
    static func applyOn(_ cell: StickerCollectionViewCell) {
        typealias context = Contexts.StickerCell
        
        cell.topView.layer.cornerRadius = cell.topView.height / 8
        cell.topView.backgroundColor = context.topViewBackgroundColor
        
        cell.cellLabel.textColor = context.textColor
        cell.imageTintColor = context.imageTint
    }
    
    static func applyOn(_ view: EmptyStickerGridView) {
        typealias context = Contexts.EmptyStickerGridView
        
        view.backgroundColor = context.backgroundColor
        
        view.stackView.spacing = 10
        
        view.label.text = "😵"
        
        view.textLabel.text = L10n.haventMadeStickersYet
        view.textLabel.customFont = UIFont(name: Fonts.Bold, size: 40)
        
        view.button.setTitle(L10n.makeYourFirstSticker, for: .normal)
        view.button.backgroundColor = context.buttonColor
        view.button.cornerRadius = view.button.height / 3
    }
    
    static func applyOn(_ view: HeaderCollectionReusableView) {
        typealias context = Contexts.CollectionViewHeader
        
        view.backgroundColor = context.backgroundColor
        
        view.topBarViewLabel.text = "My Stickers"
        view.topBarViewLabel.textColor = context.textColor
        view.topBarViewLabel.textAlignment = .center
        view.topBarViewLabel.baselineAdjustment = .alignCenters
        view.topBarViewLabel.customFont = UIFont(name: Fonts.pacificoRegular, size: 200)!
    }
}
