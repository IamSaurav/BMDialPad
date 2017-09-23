//
//  ViewController.swift
//  DialPad
//
//  Created by Saurav Satpathy on 18/09/17.
//  Copyright © 2017 Saurav Satpathy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dialView: BMDialView = BMDialView()
        dialView.setupDialPad(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(dialView)
        dialView.callTapped = { number in
            print(number)
        }
        
    }

    


}

