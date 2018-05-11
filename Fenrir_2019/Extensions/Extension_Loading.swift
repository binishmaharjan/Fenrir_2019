//
//  Extension_Loading.swift
//  Fenrir_2019
//
//  Created by guest on 2018/05/02.
//  Copyright © 2018年 guest. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    
    //Function to dislay the spinner
    class func displaySpinner(onView : UIView, title : String) -> UIView {
        //Variables
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        //Big Translucent View On Back
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        
        //Customizing the Label
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        //Customizing the Black View for the Indicator and Label
        effectView.frame = CGRect(x: spinnerView.frame.midX - strLabel.frame.width/2, y: spinnerView.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        //Cuztomizing the ActivityIndicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        //Adding the view to parent
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        spinnerView.addSubview(effectView)
        
        onView.addSubview(spinnerView)
        
        return spinnerView
    }
    
    //Function to remove the spinner
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
