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
}

class DragableView: UIView {
    
    static let maxTranslationPointY: CGFloat = 200
    static let appropiateVelocity: CGFloat = 500
    @IBOutlet weak var zizouView: UIImageView!
    
    weak var delegate: DragableViewDelegate?
    
    private var presentationState: PresentationState = .minimized {
        didSet {
            self.handlePresesntationState(presentationState)
        }
    }
    
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
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        setUpGestures()
    }
    
    private func setUpGestures() {
        self.upView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        self.upView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(maximize)))
        self.downView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minimize)))
        self.downView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
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
    
    func handlePresesntationState(_ state: PresentationState) {
        
        UIView.animate(withDuration: 0.5) {
            switch state {
            case .minimized:
                self.upView.alpha = 1
                self.downView.alpha = 0
                self.zizouView.alpha = 0
            case .maximized:
                self.upView.alpha = 0
                self.downView.alpha = 1
                self.zizouView.alpha = 1
            }
        }
    }
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            let needToMaximize = translation.y < -DragableView.maxTranslationPointY ||
                velocity.y < -DragableView.appropiateVelocity
            needToMaximize ? self.maximize() : self.minimize()
        })
    }
    
    fileprivate func handlePanchanged(_ gesture: UIPanGestureRecognizer) {

        switch presentationState {
        case .maximized:
            let translation = gesture.translation(in: self.superview)
            guard translation.y > 0 else { return }
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .minimized:
            let translation = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            self.upView.alpha = 1 + translation.y / DragableView.maxTranslationPointY
            self.zizouView.alpha = -translation.y / DragableView.maxTranslationPointY
            self.downView.alpha = -translation.y / DragableView.maxTranslationPointY
        }
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
