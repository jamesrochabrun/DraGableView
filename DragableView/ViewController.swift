//
//  ViewController.swift
//  DragableView
//
//  Created by James Rochabrun on 4/5/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dragableViewtopAnchor: NSLayoutConstraint!
    @IBOutlet weak var dragableView: DragableView! {
        didSet {
            dragableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
    }
}

extension ViewController: DragableViewDelegate {
    
    func maximizeView() {
        //70 represents the space on top
        dragableViewtopAnchor.constant = -self.view.frame.height + 70
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func minimizeView() {
        //-50 represents the header height
        dragableViewtopAnchor.constant = -50
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
}




















