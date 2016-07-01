//
//  ViewController.swift
//  CustomSwiping
//
//  Created by Эллина Кузнецова on 29.06.16.
//  Copyright © 2016 Эллина Кузнецова. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dragManager = DraggableCardsManagerView(frame: self.view.frame)
        dragManager.prepareView(4)
        self.view.addSubview(dragManager)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

