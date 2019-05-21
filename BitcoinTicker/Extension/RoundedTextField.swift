//
//  RoundedTextField.swift
//  SwinjectMVVMSample
//
//  Created by Sumit Anantwar on 22/12/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedTextField: UITextField {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return insetRectFor(bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return insetRectFor(bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return insetRectFor(bounds)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.borderStyle = .none
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension RoundedTextField {
    
    func insetRectFor(_ bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
    }
    
}
