//
//  PasscodeSignPlaceholderView.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
open class PasscodeSignPlaceholderView: UIView {
    
    public enum State {
        case inactive
        case active
        case error
    }
    
    @IBInspectable
    open var inactiveColor: UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    open var activeColor: UIColor = UIColor.gray {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    open var errorColor: UIColor = UIColor.red {
        didSet {
            setupView()
        }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupInnerPinCircle()
    }
    
    open override var intrinsicContentSize : CGSize {
        
        return CGSize(width: 16, height: 16)
    }
    
    fileprivate var innerPinCircleView: UIView!
    
    fileprivate func setupInnerPinCircle() {
        innerPinCircleView = UIView(frame: CGRect(x: 3, y: 3, width: 10, height: 10))
        innerPinCircleView.backgroundColor = inactiveColor
        innerPinCircleView.layer.cornerRadius = 5
        innerPinCircleView.isHidden = true
        
        addSubview(innerPinCircleView)
    }
    
    fileprivate func setupView() {
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = activeColor.cgColor
        backgroundColor = inactiveColor
    }
    
    fileprivate func colorsForState(_ state: State) -> (backgroundColor: UIColor, borderColor: UIColor) {
        
        switch state {
        case .inactive: return (inactiveColor, activeColor)
        case .active: return (activeColor, activeColor)
        case .error: return (errorColor, errorColor)
        }
    }
    
    open func animateState(_ state: State) {
        
        let colors = colorsForState(state)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.innerPinCircleView.isHidden = state == .inactive
                self.innerPinCircleView.backgroundColor = colors.backgroundColor
                self.layer.borderColor = colors.borderColor.cgColor
            },
            completion: nil
        )
    }
}
