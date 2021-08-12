//
//  UIViewExtensions.swift
//  PSKit
//
//  Created by 沈闻欣 on 2021/8/12.
//  Copyright © 2021 swx. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Gesture

fileprivate var tapGestureKey = "tapGestureKey"
fileprivate var tapClosureKey = "tapClosureKey"

public extension UIView {
    
    func addTapGesture(_ closure: @escaping (UITapGestureRecognizer) -> Void) {
        var tap: UITapGestureRecognizer? = objc_getAssociatedObject(self, &tapGestureKey) as? UITapGestureRecognizer
        if tap == nil {
            tap = UITapGestureRecognizer(target: self, action: #selector(__tapEventHandle(tap:)))
            if let t = tap {
                self.addGestureRecognizer(t)
                objc_setAssociatedObject(self, &tapGestureKey, t, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            objc_setAssociatedObject(self, &tapClosureKey, closure, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func __tapEventHandle(tap: UITapGestureRecognizer?) {
        if let t = tap, t.state == .recognized {
            let closure = objc_getAssociatedObject(self, &tapClosureKey) as? (UITapGestureRecognizer) -> Void
            closure?(t)
        }
    }
}
