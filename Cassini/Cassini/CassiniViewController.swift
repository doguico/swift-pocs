//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Guido Corazza on 10/9/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    // MARK: - Navigation

    private let urls: Dictionary<String, URL?> =
    [
    "Cassini": URL(string: "https://saturn.jpl.nasa.gov/system/feature_items/images/32_CGF_STILL_00025_320.jpg"),
    "Earth": URL(string: "https://www.nasa.gov/centers/goddard/images/content/638831main_globe_east_2048.jpg"),
    "Saturn": URL(string: "https://www.jpl.nasa.gov/edu/images/news/saturn_fring_bright.jpg")
    ]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if primaryViewController.contents == self {
            if let ivc = (secondaryViewController.contents as? ImageViewController) {
                if ivc.imageURL == nil {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = urls[segue.identifier ?? ""] {
            if let destination = (segue.destination.contents as? ImageViewController) {
                destination.imageURL = url
                destination.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
}

extension UIViewController{
    var contents: UIViewController {
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        }
        else {
            return self
        }
    }
}
