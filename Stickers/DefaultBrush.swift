//
//  Brush.swift
//  Stickers
//
//  Created by Craig Holliday on 3/25/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import SwifterSwift

class DefaultBrush: Object, Mappable {
    
    dynamic lazy var brushKey: String? = { self.brushName }()
//    dynamic var key = UUID().uuidString
    dynamic var brushName: String? = nil
    dynamic var brushWidth: Float = 5
    dynamic var brushAlpha: Float = 1.0
    dynamic var brushColorHexString: String = "#00000"
    dynamic var active: Bool = false
    
    override static func primaryKey() -> String? {
        return "brushKey"
    }
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        brushName <- map["brushName"]
        brushWidth <- map["brushWidth"]
        brushAlpha <- map["brushAlpha"]
        brushColorHexString <- map["brushColorHexString"]
        active <- map["active"]
    }
    
    func getWidth() -> CGFloat {
        return CGFloat(self.brushWidth)
    }
    
    func getAlpha() -> CGFloat {
        return CGFloat(self.brushAlpha)
    }
    
    func getColor() -> UIColor {
       return UIColor(hexString: self.brushColorHexString)!
    }
}

extension DefaultBrush {
    func save() {
        let realm = try! Realm()
        
        let firstItem = realm.objects(DefaultBrush.self).first
        
        if firstItem?.brushKey == self.brushKey { return }
        
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    class func all() -> Results<DefaultBrush> {
        let realm = try! Realm()
        return realm.objects(DefaultBrush.self)
    }
    
    func update(name: String) {
        let realm = try! Realm()
        try! realm.write {
            self.brushName = name
        }
    }
    
    func update(brushWidth: Float) {
        let realm = try! Realm()
        try! realm.write {
            self.brushWidth = brushWidth
        }
    }
    
    func update(brushAlpha: Float) {
        let realm = try! Realm()
        try! realm.write {
            self.brushAlpha = brushAlpha
        }
    }
    
    func update(brushColorHexString: String) {
        let realm = try! Realm()
        try! realm.write {
            self.brushColorHexString = brushColorHexString
        }
    }
    
    func update(active: Bool) {
        let realm = try! Realm()
        
        try! realm.write {
            self.active = active
        }
    }
    
    func setActive(brush: DefaultBrush) {
        let realm = try! Realm()
        
        let allBrush = DefaultBrush.all()
        
        try! realm.write {
            for item in allBrush {
                if item == brush {
                    item.active = true
                    return
                }
                item.active = false
            }
        }
    }

    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    class func getActive() -> DefaultBrush! {
        let allBrushProperties = DefaultBrush.all()
        if let allBrushProperties = allBrushProperties.filter("active == true").first {
            return allBrushProperties
        }
        return nil
    }
    
    static func createDefaultBrush() {
        let brush = DefaultBrush()
        brush.brushName = "Default"
        brush.active = true
        brush.save()
    }
}
