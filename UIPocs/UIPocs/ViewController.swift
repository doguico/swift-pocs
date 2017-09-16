//
//  ViewController.swift
//  UIPocs
//
//  Created by Guido Corazza on 9/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var landscapeview: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        adjustLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustLayout()
    }
    
    func adjustLayout() {
        landscapeview.isHidden = UIDevice.current.orientation.isLandscape ? false : true
    }
}
