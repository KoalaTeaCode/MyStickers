//
//  StoryboardIdentifiable.swift
//  Stickers
//
//  Created by Craig Holliday on 4/5/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
