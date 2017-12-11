//
//  testViewController.swift
//  corelocationAR
//
//  Created by Syed ShahRukh Haider on 17/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import CircleMenu

class testViewController: UIViewController,CircleMenuDelegate {

    
    @IBOutlet weak var menu: CircleMenu!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menu.delegate = self
        
    }

   
    var i = 0
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
      button.titleLabel?.text = "\(self.i = i + 1)"
        print("hello")
        print(atIndex)
        print(button.currentTitle)
        let fb = UIImage(named: "facebook.png")
        button.backgroundColor = UIColor.clear
        button.setImage(fb, for: .normal)
//        let button = CircleMenu(
//            frame: CGRect(x: 200, y: 200, width: 50, height: 50),
//            normalIcon:"facebook",
//            selectedIcon:"",
//            buttonsCount: 1,
//            duration: 2,
//            distance: 120)
//        button.delegate = self
//        button.layer.cornerRadius = button.frame.size.width / 2.0
//        view.addSubview(button)
        
        
    }

    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print(atIndex)
    }

}
