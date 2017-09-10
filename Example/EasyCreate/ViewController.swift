//
//  ViewController.swift
//  EasyCreate
//
//  Created by kkendall33 on 09/10/2017.
//  Copyright (c) 2017 kkendall33. All rights reserved.
//

import UIKit
import EasyCreate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let someView = SomeView.viewFromNib()
        view.addSubview(someView)
    }
    
}

class SomeView: UIView, NibInstantiating {
    
}

