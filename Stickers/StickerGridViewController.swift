//
//  StickerGridViewController.swift
//  Stickers
//
//  Created by Craig Holliday on 4/5/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import KoalaTeaFlowLayout
import RealmSwift
import Reusable

private let reuseIdentifier = "Cell"

class StickerGridViewController: UIViewController {
    
    var emptyView: UIView!
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let titleLabel = LabelWithAdaptiveTextHeight()
    
    var stickers: Results<StickerModel> = {
        var stickers: Results<StickerModel>

        stickers = StickerModel.all()
        
        return stickers
    }()
    
    var token: NotificationToken?
    var isExtension: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isExtension = Helpers.isAppExtension()

        setupCollectionView()
        setupEmptyView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        Stylesheet.applyOn(self)
        setupNavBar()
    }
    
    func setupEmptyView() {
        emptyView = EmptyStickerGridView(frame: self.view.frame, fromViewController: self)
        
        emptyView.isHidden = true
        self.view.addSubview(emptyView)
    }
    
    func showEmptyView() {
        guard emptyView.isHidden else { return }
        self.view.bringSubview(toFront: emptyView)
        self.emptyView.isHidden = false
    }
    
    func hideEmptyView() {
        guard !emptyView.isHidden else { return }
        self.emptyView.isHidden = true
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.topItem?.titleView = titleLabel
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        registerNotifications()
        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }

        self.collectionView.register(cellType: StickerCollectionViewCell.self)
        self.collectionView.register(supplementaryViewType: HeaderCollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
        
        let layout = KoalaTeaFlowLayout(ratio: 1.0, topBottomMargin: 8, leftRightMargin: 8, cellsAcross: 4.0, cellSpacing: 4)
        self.collectionView.collectionViewLayout = layout
    }
    
    func registerNotifications() {
        token = stickers.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                let deleteIndexPaths = deletions.map { IndexPath(item: $0, section: 0) }
                let insertIndexPaths = insertions.map { IndexPath(item: $0, section: 0) }
                let updateIndexPaths = modifications.map { IndexPath(item: $0, section: 0) }
                
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.deleteItems(at: deleteIndexPaths)
                    self?.collectionView.insertItems(at: insertIndexPaths)
                    self?.collectionView.reloadItems(at: updateIndexPaths)
                }, completion: nil)
                
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
}

extension StickerGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var extraCells = 0
        
        if !isExtension {
            extraCells = 1
        }
        
        guard stickers.count != 0 else {
            self.showEmptyView()
            
            return extraCells
        }
        self.hideEmptyView()
        return stickers.count + extraCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: StickerCollectionViewCell.self, for: indexPath)
        
        if indexPath.row >= stickers.count {
            cell.configureAddCell()
            
            return cell
        }

        // Configure the cell
        let item = stickers[indexPath.row]
        
        cell.configureCell(stickerModel: item, isExtension: self.isExtension)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isExtension else { return }
        
        var item: StickerModel! = nil
    
        if indexPath.row < stickers.count {
            item = stickers[indexPath.row]
            self.showStickerActionSheet(stickerModel: item)
            return
        }
        
        let vc = CanvasViewController()
        let navVc = UINavigationController(rootViewController: vc)
        
        self.navigationController?.present(navVc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard isExtension else { return UICollectionReusableView() }
        
        let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: HeaderCollectionReusableView.self, for: indexPath)
        
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard isExtension else { return CGSize(width: 0, height: 0) }
        
        return CGSize(width: self.collectionView.width, height: self.view.height / 16)
    }
}

extension StickerGridViewController {
    func showStickerActionSheet(stickerModel: StickerModel) {

        let alert = UIAlertController(title: L10n.selectedSticker, message: stickerModel.getName(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: L10n.editSticker, style: .default, handler: { (action) -> Void in
            let vc = CanvasViewController()
            let navVc = UINavigationController(rootViewController: vc)
            vc.selectedStickerModel = stickerModel
            self.present(navVc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: L10n.deleteSticker, style: .destructive, handler: { (action) -> Void in
            self.showDeleteSecondCheckAlertView(stickerModel: stickerModel)
        }))
        alert.addAction(UIAlertAction(title: L10n.goBack, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeleteSecondCheckAlertView(stickerModel: StickerModel) {
        let alert = UIAlertController(title: L10n.areYouSure, message: L10n.itWillBeGoneForever, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: L10n.killIt, style: .destructive, handler: { (action) -> Void in
            stickerModel.delete()
        }))
        alert.addAction(UIAlertAction(title: L10n.keepIt, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
