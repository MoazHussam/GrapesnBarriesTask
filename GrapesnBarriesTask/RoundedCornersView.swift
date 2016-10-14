//
//  RoundedCornersView.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

protocol RoundedCornersViews {
    var cornerRadius: CGFloat { set get }
    
}

extension RoundedCornersViews {
    
    func setRoundedCorners(forView view: UIView) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = cornerRadius > 0
    }
}

@IBDesignable
class RoundedCornersView: UIView, RoundedCornersViews {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      setRoundedCorners(forView: self)
    }
  }
  
}
