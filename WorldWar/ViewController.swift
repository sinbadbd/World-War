//
//  ViewController.swift
//  WorldWar
//
//  Created by sinbad on 6/14/19.
//  Copyright © 2019 sinbad. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameScene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(gameScene)
        
    }


}

