//
//  HeaderReusableView.swift
//  GrapesnBarriesTask
//
//  Created by Moaz Ahmed on 10/14/16.
//  Copyright © 2016 Moaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

class HeaderReusableView : UICollectionReusableView, RoundedCornersViews {
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            setRoundedCorners(forView: self)
        }
    }

}
