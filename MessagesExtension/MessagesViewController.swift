//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Craig Holliday on 3/29/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import Messages
import RealmSwift
import SwiftyBeaver
let log = SwiftyBeaver.self
import SnapKit
import FontBlaster

class MessagesViewController: MSMessagesAppViewController {
    
    var browserViewController: StickerGridViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup swifty beaver
        let console = ConsoleDestination()
        log.addDestination(console) // add to SwiftyBeaver
        
        // Setup realm configuration
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Messages.Realm")!
        var config = Realm.Configuration()
        config.fileURL = directory.appendingPathComponent("db.realm")
        Realm.Configuration.defaultConfiguration = config
        
        FontBlaster.debugEnabled = false
        FontBlaster.blast { (fonts) -> Void in
//            print("Loaded Fonts", fonts)
        }
        
        self.browserViewController = StickerGridViewController()
        self.browserViewController.view.frame = self.view.bounds
        self.browserViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChildViewController(self.browserViewController)
        
        self.view.addSubview(self.browserViewController.view)
        
        self.browserViewController.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        self.browserViewController.didMove(toParentViewController: self)
        
        return
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
}
