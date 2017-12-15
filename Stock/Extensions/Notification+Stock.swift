//
//  Notification+Stock.swift
//  Stock
//
//  Created by Kim Younghoo on 12/13/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import Foundation
import UIKit

//[C2-5]
struct KeyboardData {
    public var frame = CGRect.zero
    public var animationDuration: TimeInterval = 0.2
    public var animationCurve = UIViewAnimationOptions()
}

//[C2-5]
extension Notification {
    var keyboardData: KeyboardData? {
        guard let userInfo = userInfo, let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        
        var keyboardData = KeyboardData()
        keyboardData.frame = endFrame
        if let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            keyboardData.animationDuration = animationDuration
        }
        if let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            keyboardData.animationCurve = UIViewAnimationOptions(rawValue: animationCurveRawNSN)
        }
        return keyboardData
    }
}
