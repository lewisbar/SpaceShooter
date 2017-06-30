//
//  CGSize+center.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 29.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import UIKit

extension CGSize {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}
