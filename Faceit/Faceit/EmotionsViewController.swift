//
//  EmotionsViewController.swift
//  Faceit
//
//  Created by Guido Corazza on 9/19/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController, UISplitViewControllerDelegate {
    
    var collapseDetailViewController = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        collapseDetailViewController = false
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController{
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = expressions[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
        
    }
    
    private var expressions: Dictionary<String, FacialExpression> = [
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool{
        return collapseDetailViewController
    }
    
}
