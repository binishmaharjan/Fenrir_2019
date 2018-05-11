//
//  NavigationBarController.swift
//  Fenrir_2019
//
//  Created by guest on 2018/05/01.
//  Copyright © 2018年 guest. All rights reserved.
//

import UIKit

class NavigationBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Bar tint color of the navigation bar
        self.navigationBar.barTintColor = Colors.color_1
        
        //Tint color of the navigation bar
        self.navigationBar.tintColor = Colors.color_5
        
        //Changing the color of title of the navigation bar
        let attrs = [
            NSAttributedStringKey.foregroundColor: Colors.color_5
        ]
        
        self.navigationBar.titleTextAttributes = attrs
        
        //Making the navigation bar non transulcent
        self.navigationBar.isTranslucent = false
        
        UIApplication.shared.statusBarStyle = .lightContent


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
