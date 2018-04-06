//
//  DragableView.swift
//  DragableView
//
//  Created by James Rochabrun on 4/5/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol DragableViewDelegate: class {
    func maximizeView()
    func minimizeView()
}

enum PresentationState {
    case minimized
    case maximized
    case maxAllowDraging
}

class DragableView: UIView {
    
    static let maxTranslationPointY: CGFloat = 200
    @IBOutlet weak var zizouView: UIImageView!
    
    weak var delegate: DragableViewDelegate?
    
    private var presentationState: PresentationState = .minimized
    
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var downView: UIView!
    
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DragableView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
        self.downView.layer.cornerRadius = 15
        self.upView.layer.cornerRadius = 15
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.upView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maximize)))
        self.downView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minimize)))

    }

    //MARK: - the good stuff
    @objc func maximize() {
        delegate?.maximizeView()
        presentationState = .maximized
    }
    
     @objc func minimize() {
        delegate?.minimizeView()
        presentationState = .minimized
    }
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translation.y < -DragableView.maxTranslationPointY ||
                velocity.y < -500 {
                self.delegate?.maximizeView()
            } else {
                self.delegate?.minimizeView()
                self.upView.alpha = 1
               // self.zizouView.alpha = 0
                self.downView.alpha = 0
            }
        })
    }
    
    fileprivate func handlePanchanged(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.upView.alpha = 1 + translation.y / DragableView.maxTranslationPointY
     //   self.zizouView.alpha = -translation.y / DragableView.maxTranslationPointY
        self.downView.alpha = -translation.y / DragableView.maxTranslationPointY
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            break
        case .changed:
            handlePanchanged(gesture)
        case .ended:
            handlePanEnded(gesture)
        case .possible, .cancelled, .failed:
            break
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
