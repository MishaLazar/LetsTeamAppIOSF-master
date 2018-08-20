//
//  UiViewCardEffect.swift
//  LetsTeamApp
//
//  Created by admin on 8/4/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

@IBDesignable class UiViewCardEffect: UIView {
    
    @IBInspectable var cornerradius : CGFloat = 0.2
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    @IBInspectable var shadowOffSetHeight : CGFloat = 5
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        layer.shadowColor = shadowColor.cgColor
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
 

}
