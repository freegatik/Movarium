//
//  UIView+Extensions.swift
//  Movarium
//
//  Created by Anton Solovev on 19.10.2024.
//

// MARK: Getting parent UIViewController
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
