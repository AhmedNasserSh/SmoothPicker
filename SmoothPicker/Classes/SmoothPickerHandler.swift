//
//  SmoothPickerHandler.swift
//  SmoothPicker
//
//  Created by Ahmed Nasser on 2/11/19.
//  Copyright © 2019 Ahmed Nasser. All rights reserved.
//

import Foundation
import UIKit
protocol SmoothPickerScrollDelegate {
    var scrollView : UIScrollView {get}
    var itemsCount :Int {set get}
    var itemsWidth : [CGFloat] {set get}
    var didEndDragging : Bool {set get}
    func scrollToItem(index:Int)
    func handleSelection(index:Int)
}
public class SmoothPickerHandler :NSObject,UIScrollViewDelegate{
    private var indexOfCellBeforeDragging = 0
    private var delegate :SmoothPickerScrollDelegate?
    private var itemsCount :Int = 0
    private var itemsWidth = [CGFloat]()
    private var prefixes = [CGFloat]()
    init(_ delegate :SmoothPickerScrollDelegate) {
        super.init()
        self.delegate = delegate
        self.itemsCount = delegate.itemsCount
        self.itemsWidth = delegate.itemsWidth
        self.sumPreFixes()
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.didEndDragging = false
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        // handle the swipe scrolling
        let didUseSwipeToSkipCell = handleSwipeScrolling(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        if !didUseSwipeToSkipCell {
            self.delegate?.scrollToItem(index: indexOfMajorCell)
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging = true
        let index = indexOfMajorCell()
        self.delegate?.handleSelection(index: index)
    }
    private func handleSwipeScrolling(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) ->Bool{
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // by observation
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < itemsCount  && velocity.x > swipeVelocityThreshold
        
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = self.indexOfMajorCell() != indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            // Here we’ll add the code to snap the next cell
            // or to the previous cell
            let snapToIndex = indexOfMajorCell()
            let snapToValue =  snapToIndex
            let toValue = prefixes[snapToValue]
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                self.delegate?.handleSelection(index: snapToIndex)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        }
        return didUseSwipeToSkipCell
    }
    
    func indexOfMajorCell() -> Int {
        let currentOffset = (self.delegate?.scrollView.contentOffset.x)!
        let index = searchOffsets(offset: currentOffset)
        let safeIndex = max(0, min(itemsCount - 1 , index))
        return safeIndex
    }
    private func sumPreFixes() {
        var i :CGFloat = 0
        for width in itemsWidth {
            i += width
            prefixes.append(i)
        }
    }
    private func searchOffsets(offset:CGFloat) -> Int {
        if let index = prefixes.last(where: { (prefix) -> Bool in
            return offset > prefix
        }) {
            return prefixes.firstIndex(of: index)! + 1
        }
        return 0
    }
}

