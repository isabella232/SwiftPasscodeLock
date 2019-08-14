//
//  PasscodeLockPresenter.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

open class PasscodeLockPresenter {
    
    fileprivate var mainWindow: UIWindow?
    fileprivate var passcodeLockWindow: UIWindow?
    
    fileprivate let passcodeConfiguration: PasscodeLockConfigurationType
    fileprivate let passcodeState: PasscodeLockStateType
    
    public let passcodeLockVC: PasscodeLockViewController
    open var isPasscodePresented = false
    
    public init(mainWindow window: UIWindow?,
                configuration: PasscodeLockConfigurationType,
                state: PasscodeLockStateType) {
        mainWindow = window
        passcodeConfiguration = configuration
        passcodeState = state
        passcodeLockVC = PasscodeLockViewController(state: passcodeState, configuration: passcodeConfiguration)
    }
    
    open func presentPasscodeLock() {
        guard passcodeConfiguration.repository.hasPasscode else { return }
        guard !isPasscodePresented else { return }
        
        isPasscodePresented = true
        
        mainWindow?.endEditing(true)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = mainWindow!.windowLevel + 1
        window.makeKeyAndVisible()
        passcodeLockWindow = window
        
        let userDismissCompletionCallback = passcodeLockVC.dismissCompletionCallback
        
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            userDismissCompletionCallback?()
            self?.dismissPasscodeLock()
        }
        
        window.rootViewController = passcodeLockVC
    }
    
    open func dismissPasscodeLock(animated: Bool = true) {
        isPasscodePresented = false
        
        if animated {
            animatePasscodeLockDismissal()
        } else {
            passcodeLockWindow?.rootViewController = nil
            passcodeLockWindow?.isHidden = true
            passcodeLockWindow = nil
            mainWindow?.makeKeyAndVisible()
        }
    }
    
    internal func animatePasscodeLockDismissal() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.passcodeLockWindow?.alpha = 0
            },
            completion: { _ in
                self.passcodeLockWindow?.rootViewController = nil
                self.passcodeLockWindow?.isHidden = true
                self.passcodeLockWindow = nil
                self.mainWindow?.makeKeyAndVisible()
            }
        )
    }
}
