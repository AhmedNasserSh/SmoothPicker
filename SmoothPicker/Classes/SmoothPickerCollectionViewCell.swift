//
//  SmoothPickerCollectionViewCell.swift
//  SmoothPicker
//
//  Created by Ahmed Nasser on 2/11/19.
//  Copyright © 2019 Ahmed Nasser. All rights reserved.
//


import UIKit
import SnapKit
class SmoothPickerCollectionViewCell: UICollectionViewCell {
    var view:UIView?
    internal var scrollSelected = false
    var delegate :SmoothPickerViewDelegate?
    func setContentView(_ view:UIView) {
        if SmoothPickerConfiguration.selectionStyle == .colored  {
             view.backgroundColor = SmoothPickerConfiguration.dimmedColor
        }
        for cellView in self.contentView.subviews {
            cellView.removeFromSuperview()
        }
        self.view = view
        self.contentView.bounds = (self.view?.frame)!
        self.contentView.addSubview(view)
    }
    func setSelected (selected : Bool) {
        self.scrollSelected = selected
        if SmoothPickerConfiguration.selectionStyle == .colored {
            coloredSelected()
        }else{
            scaledSelected()
        }
        view?.setSmoothSelected(selected)
    }
    private func coloredSelected() {
        let color = scrollSelected ? SmoothPickerConfiguration.selectedColor:SmoothPickerConfiguration.dimmedColor
        self.view?.backgroundColor = color
    }
    private func scaledSelected(){
        let scale :CGFloat = scrollSelected ? 1.3 : 1
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
extension UIView {
    @objc open func setSmoothSelected(_ selected : Bool) {
    }
}
