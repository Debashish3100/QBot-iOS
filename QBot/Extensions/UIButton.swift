//
//  UIButton.swift
//  QBot
//
//  Created by Debashish Das on 04/11/20.
//  Copyright © 2020 debashish. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    func addShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
}
