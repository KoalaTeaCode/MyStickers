//
//  ViewController.swift
//  Stickers
//
//  Created by Craig Holliday on 3/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SnapKit
import NXDrawKit
import IGColorPicker
import SwifterSwift

class CanvasViewController: UIViewController {
    
    var canvasContainerView = UIView()
    weak var canvasView: Canvas?
    var bottomView = UIView()
    var rightBarButton: UIButton!
    
    var colorPickerView: ColorPickerView!
    var currentBrush: DefaultBrush! = { return DefaultBrush.getActive() }()
    
    var controlsViewIsVisible = false
    
    var controlsView = ControlsView()
    var toolBar = UIView()
    
    var undoButton = UIButton()
    var redoButton = UIButton()
    var brushButton = UIButton()
    var clearButton = UIButton()
    var closeButton = UIButton()
    
    var iconActiveColor = UIColor.white
    var iconDisabledColor = UIColor.gray
    
    var selectedStickerModel: StickerModel! = nil
    
    var colors: [UIColor] = {
        return [
            Stylesheet.pureColors.black,
            Stylesheet.pureColors.white,
            Stylesheet.pureColors.yellow,
            Stylesheet.pureColors.yellowOrange,
            Stylesheet.pureColors.orange,
            Stylesheet.pureColors.orangeRed,
            Stylesheet.pureColors.red,
            Stylesheet.pureColors.redPurple,
            Stylesheet.pureColors.purple,
            Stylesheet.pureColors.purpleBlue,
            Stylesheet.pureColors.blue,
            Stylesheet.pureColors.blueGreen,
            Stylesheet.pureColors.green,
            Stylesheet.pureColors.greenYellow
        ]
    }()
    
    var exitBarButton = UIBarButtonItem()
    var saveBarButton = UIBarButtonItem()
    
    var alertTextField = UITextField()
    var alertView = UIAlertController()
    var saveAlertAction = UIAlertAction()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        performLayout()
        setTitle()
    }
    
    override func viewDidLayoutSubviews() {
        setToolbarIcons()
        Stylesheet.applyOn(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTitle() {
        self.title = L10n.newSticker
        
        guard let sticker = selectedStickerModel else { return }
        
        self.title = sticker.getName()
    }

    func performLayout() {
        self.view.addSubview(canvasContainerView)
        
        canvasContainerView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalToSuperview()
            make.height.equalTo(canvasContainerView.snp.width)
        }
        
        var newCanvas = Canvas()
        if let sticker = selectedStickerModel {
            newCanvas = Canvas(canvasId: sticker.getName(), backgroundImage: sticker.getImage())
        }
        
        newCanvas.clipsToBounds = true
        newCanvas.delegate = self
        self.canvasContainerView.addSubview(newCanvas)
        self.canvasView = newCanvas
        
        self.canvasView?.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.view.addSubview(bottomView)

        bottomView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }
        
        setupNavigationBar()
        setupToolBar()
        setupColorPicker()
        setupControlsView()
    }
    
    func setupNavigationBar() {
        exitBarButton.title = L10n.exit
        exitBarButton.target = self
        exitBarButton.action = #selector(self.onClickExitButton)
        
        saveBarButton.title = L10n.save
        saveBarButton.target = self
        saveBarButton.action = #selector(self.onClickSaveButton)
        
        self.navigationItem.leftBarButtonItem = exitBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        if let navBar = self.navigationController?.navigationBar {
            extendedLayoutIncludesOpaqueBars = true
            navBar.isTranslucent = true
            navBar.backgroundColor = UIColor.clear
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
        }
    }

    func setupControlsView() {
        self.bottomView.addSubview(controlsView)
                
        controlsView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func toggleBottomView() {
        if !controlsViewIsVisible {
            bottomView.snp.remakeConstraints { (make) -> Void in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview().dividedBy(4)
            }
            
            controlsViewIsVisible = true
        } else {
            bottomView.snp.remakeConstraints { (make) -> Void in
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(0)
            }
            
            controlsViewIsVisible = false
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension CanvasViewController {
    func setupToolBar() {
        self.view.addSubview(toolBar)
        toolBar.addSubview(undoButton)
        toolBar.addSubview(redoButton)
        toolBar.addSubview(brushButton)
        toolBar.addSubview(clearButton)
        toolBar.addSubview(closeButton)
        
        undoButton.addTarget(self, action: #selector(self.onClickUndoButton), for: .touchUpInside)
        redoButton.addTarget(self, action: #selector(self.onClickRedoButton), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(self.onClickClearButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(self.toggleBottomView), for: .touchUpInside)
        
        toolBar.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView.snp.top).priority(100)
            make.bottom.equalToSuperview().priority(99)
            make.width.equalToSuperview()
            make.height.equalToSuperview().dividedBy(12)
        }
        
        undoButton.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        redoButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(undoButton.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
        
        brushButton.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    func setToolbarIcons() {
        let height = toolBar.height / 2
        undoButton.setIcon(icon: .fontAwesome(.undo), iconSize: height, color: iconActiveColor, forState: .normal)
        undoButton.setIcon(icon: .fontAwesome(.undo), iconSize: height, color: iconDisabledColor, forState: .disabled)
        redoButton.setIcon(icon: .fontAwesome(.repeatIcon), iconSize: height, color: iconActiveColor, forState: .normal)
        redoButton.setIcon(icon: .fontAwesome(.repeatIcon), iconSize: height, color: iconDisabledColor, forState: .disabled)
        brushButton.setIcon(icon: .fontAwesome(.paintBrush), iconSize: height, color: iconActiveColor, forState: .normal)
        brushButton.addTarget(self, action: #selector(self.toggleBottomView), for: .touchUpInside)
        clearButton.setTitle(L10n.clear, for: .normal)
        clearButton.sizeToFit()
        clearButton.setTitleColor(iconActiveColor, for: .normal)
        clearButton.setTitleColor(iconDisabledColor, for: .disabled)
        
        updateToolBarButtonStatus(self.canvasView!)
    }
    
    fileprivate func updateToolBarButtonStatus(_ canvas: Canvas) {
        self.undoButton.isEnabled = canvas.canUndo()
        self.redoButton.isEnabled = canvas.canRedo()
        self.clearButton.isEnabled = canvas.canClear()
        self.saveBarButton.isEnabled = canvas.canSave()
    }
    
    func onClickUndoButton() {
        self.canvasView?.undo()
    }
    
    func onClickRedoButton() {
        self.canvasView?.redo()
    }
    
    func onClickExitButton() {
        guard let canSave = self.canvasView?.canSave() else { return }
        
        if canSave {
            self.showExitCheckAlert()
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func onClickSaveButton() {
        self.canvasView?.save()
    }
    
    func onClickClearButton() {
        self.canvasView?.clear()
    }
}

extension CanvasViewController: ColorPickerViewDelegate, ColorPickerViewDelegateFlowLayout {
    // MARK: Color Slider
    func setupColorPicker() {
        colorPickerView = ColorPickerView(frame: CGRect(x: 0.0, y: 0.0, width: 0, height: 0))
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.colors = colors
        colorPickerView.style = .square
        colorPickerView.selectionStyle = .check
        colorPickerView.isSelectedColorTappable = false
        colorPickerView.preselectedIndex = colorPickerView.colors.indices.first
        self.view.addSubview(colorPickerView)
        
        colorPickerView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(0)
            make.right.equalToSuperview().inset(0)
            make.height.equalToSuperview().dividedBy(12)
            make.bottom.equalTo(toolBar.snp.top)
        }
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
        let color = colorPickerView.colors[indexPath.item]
        currentBrush.update(brushColorHexString: color.hexString)
    }
    
    func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - CanvasDelegate
extension CanvasViewController: CanvasDelegate
{
    func brush() -> Brush? {
        let activeBrushProperties = DefaultBrush.getActive()
        let brush = Brush()
        brush.color = activeBrushProperties!.getColor()
        brush.width = activeBrushProperties!.getWidth()
        brush.alpha = activeBrushProperties!.getAlpha()
        
        return brush
    }
    
    func canvas(_ canvas: Canvas, didUpdateDrawing drawing: Drawing, mergedImage image: UIImage?) {
        self.updateToolBarButtonStatus(canvas)
    }
    
    func canvas(_ canvas: Canvas, didSaveDrawing drawing: Drawing, mergedImage image: UIImage?) {
        
        // Create a new alert controller from string or Error
        let alertView = UIAlertController(title: L10n.enterAStickerName, message: "", preferredStyle: .alert)
        alertView.addTextField(text: self.title, placeholder: "Enter Sticker Name", editingChangedTarget: self, editingChangedSelector: #selector(self.textFieldDidChange(_:)))
        
        alertView.addAction(title: L10n.goBack, style: .destructive, isEnabled: true, handler: { action in
            alertView.dismiss(animated: true, completion: nil)
        })
        
        saveAlertAction = UIAlertAction(title: L10n.saveEmoji, style: .default, handler: { action in
            self.saveActionPressed(image: image!, title: self.alertTextField.text)
        })
        saveAlertAction.isEnabled = false
        
        alertView.addAction(self.saveAlertAction)
        
        self.present(alertView, animated: true, completion: nil)
        
        self.updateToolBarButtonStatus(canvas)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.alertTextField.text = textField.text
        
        if self.alertTextField.isEmpty {
            saveAlertAction.isEnabled = false
            return
        }
        self.saveAlertAction.isEnabled = true
    }
    
    func saveActionPressed(image: UIImage?, title: String!) {
        guard let stickerName = title, !title.isEmpty else { return }
        
        if selectedStickerModel != nil {
            self.selectedStickerModel.update(image: image!, fileName: stickerName, completion: { (success) -> Void in
                if success == false {
                    self.alertNameTaken()
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        let newStickerModel = StickerModel()
        newStickerModel.name = stickerName
        newStickerModel.save(image: image!, completion: { (success) -> Void in
            if success == false {
                self.alertNameTaken()
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension CanvasViewController {
    func showExitCheckAlert() {
        let alert = UIAlertController(title: L10n.areYouSure, message: L10n.youHaveUnsavedChanges, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: L10n.imOkayWithThis, style: .destructive, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: L10n.goBack, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertNameTaken(completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: L10n.error, message: L10n.alreadyAStickerWithName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.okayFine, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
