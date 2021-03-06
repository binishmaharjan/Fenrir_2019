//
//  UIView_Designable.swift
//  Fenrir_2019
//
//  Created by guest on 2018/05/01.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class UIView_Designable: UIView {

    //For Corner Radius
    @IBInspectable var CornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
    
    //For Border Color
    @IBInspectable var BorderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    // Border Width
    @IBInspectable var BorderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    
    //For Background
    @IBInspectable var Background : UIColor = UIColor.clear {
        didSet{
            self.layer.backgroundColor = Background.cgColor
        }
    }
    
    
    //For Background
    @IBInspectable var ClipBounds : Bool =   false{
        didSet{
            self.clipsToBounds = ClipBounds
        }
    }
    
    //For First Color of the Gradient
    @IBInspectable var FirstColor : UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    //For Second color of the gradient
    @IBInspectable var secondColor : UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    //Creating the new layer for the the gradient
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    //Update the gradient view
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.startPoint  = CGPoint(x: 1.0, y: 1.0)
        layer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.colors = [FirstColor.cgColor,secondColor.cgColor]
    }
    
}
