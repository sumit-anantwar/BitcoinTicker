//
//  UIView+Extensions.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 22/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func resetSubViews() {
        for view in self.view.subviews {
            view.layoutIfNeeded()
        }
    }
    
}

extension UIView {
    
    private func constraintsFor(attribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        
        let filteredArray = self.constraints.filter { $0.firstAttribute == attribute }
        var constraints: [NSLayoutConstraint] = []
        for c in filteredArray {
            if c.isActive {
                constraints.append(c)
            }
        }
        
        return constraints
    }
    
    func constraint(attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let constraints = self.constraintsFor(attribute: attribute)
        if constraints.count > 0 {
            return constraints.first
        }
        
        return nil
    }
    
    func parentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentViewController()
        } else {
            return nil
        }
    }
}
