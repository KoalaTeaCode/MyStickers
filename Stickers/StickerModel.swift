//
//  StickerModel.swift
//  Stickers
//
//  Created by Craig Holliday on 4/2/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import Messages

class StickerModel: Object, Mappable {
    dynamic var key = UUID().uuidString
    dynamic var name: String = ""
    dynamic var remoteImageURL: String? = nil
    dynamic var imageURL: String? = nil
    
    let groupURL = "group.Messages.images"
    
    override static func primaryKey() -> String? {
        //@TODO: Add userID to key
        return "key"
    }
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        
    }
    
    // Mark: Getters
    
    func getName() -> String? {
        return self.name
    }
    
    func getSticker() -> MSSticker? {
        var sticker: MSSticker!
        
        if let imageURL = self.getLocalImageURL() {
            do {
                sticker = try MSSticker(contentsOfFileURL: imageURL, localizedDescription: self.name)
                return sticker
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func getLocalImageURL() -> URL? {
        let fileManager = FileManager.default
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupURL) else {
            return nil
        }
        let storagePathUrl = groupURL.appendingPathComponent(self.getName()! + ".png", isDirectory: false)
        
        return storagePathUrl
    }
    
    func saveImage(image: UIImage, fileName: String) {
        let fileManager = FileManager.default
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupURL) else {
            return
        }
        let storagePathUrl = groupURL.appendingPathComponent(fileName + ".png", isDirectory: false)
        
        let scaledImage = image.scaleImage(toSize: CGSize(width: 618, height: 618))
        
        do {
            if let pngImageData = UIImagePNGRepresentation(scaledImage!) {
                try pngImageData.write(to: storagePathUrl, options: .atomic)
                self.update(imageURL: String(describing: storagePathUrl))
                // Timer to update model after image is for sure saved
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    
                }
                
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func removeImage(fileName: String) {
        let fileManager = FileManager.default
        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupURL) else {
            return
        }
        let storagePathUrl = groupURL.appendingPathComponent(fileName + ".png", isDirectory: false)
        let storagePath = storagePathUrl.path
        
        do {
            if fileManager.fileExists(atPath: storagePath) {
                try fileManager.removeItem(at: storagePathUrl)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func getImage() -> UIImage! {
        //@TODO: Guard and optionals
        let image = UIImage(contentsOfFile: self.getLocalImageURL()!.path)
        return image
        
    }
}

extension StickerModel {
    func save(image: UIImage, completion: ((Bool) -> Void)) {
        if self.objectExists(withName: self.getName()!) {
            completion(false)
            return
        }
        
        self.saveImage(image: image, fileName: self.getName()!)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
        
        completion(true)
    }
    
    class func all() -> Results<StickerModel> {
        let realm = try! Realm()
        return realm.objects(StickerModel.self)
    }
    
    func update(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.name = name
        }
    }
    
    func update(imageURL: String) {
        let realm = try! Realm()
        try! realm.write {
            self.imageURL = imageURL
        }
    }
    
    func update(image: UIImage, fileName: String, completion: ((Bool) -> Void)? = nil) {
        if self.objectExists(withName: fileName) {
            completion!(false)
            return
        }
        // Save new image delete old image
        
        if self.getName() != fileName {
            self.removeImage(fileName: self.getName()!)
        }
        
        self.saveImage(image: image, fileName: fileName)
        
        let realm = try! Realm()
        try! realm.write {
            self.name = fileName
            completion!(true)
        }
    }
    
    func updateFrom(item: StickerModel) {
        guard self.getName() == item.getName() else { return }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func delete() {
        self.removeImage(fileName: self.getName()!)
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func objectExists(withName name: String) -> Bool {
        let all = StickerModel.all()
        
        guard let exisitingObject = all.filter({ $0.getName() == name }).first else { return false }
        
        guard exisitingObject != self else { return false }
        
        return true
    }
}
