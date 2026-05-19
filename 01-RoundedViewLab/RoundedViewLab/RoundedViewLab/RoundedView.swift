//  RoundedView.swift

import UIKit

class RoundedView: UIView {
    public var cornerRadius: CGFloat = 0
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor = .cyan
    public var mainColor: UIColor = .systemTeal
    public var isBugMode: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isBugMode {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
            layer.backgroundColor = mainColor.cgColor
        }
    }
    
    func applyInBugMode() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = mainColor.cgColor
    }
    
}
