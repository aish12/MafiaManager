//
//  TabBarViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor(red: 0.7569, green: 0.7373, blue: 0.7686, alpha: 1.0)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
