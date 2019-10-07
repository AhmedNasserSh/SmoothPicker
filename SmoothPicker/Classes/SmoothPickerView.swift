//
//  SmoothPickerView.swift
//  SmoothPicker
//
//  Created by Ahmed Nasser on 2/11/19.
//  Copyright © 2019 Ahmed Nasser. All rights reserved.
//

import UIKit
import SnapKit
@objc public protocol SmoothPickerViewDelegate {
    func didSelectItem(index:Int,view:UIView,pickerView:SmoothPickerView)
}
@objc public protocol SmoothPickerViewDataSource {
    func numberOfItems(pickerView:SmoothPickerView) -> Int
    func itemForIndex(index:Int,pickerView:SmoothPickerView) -> UIView
}
public enum Direction {
    case  next
    case  pervious
}
@IBDesignable
open class SmoothPickerView: UIView {
    @IBOutlet open  var dataSource: SmoothPickerViewDataSource?
    @IBOutlet open  var delegate :SmoothPickerViewDelegate?
    @IBInspectable open var firstselectedItem = 0
    public var sliderCollectionView: UICollectionView?
    public var currentSelectedCell : UICollectionViewCell?
    public var sliderHandler :SmoothPickerHandler?
    public var currentSelectedIndex :Int = 0
    public var scrolledFirstTime = false
    public var loadedFirstTime = false
    public var cellIdentifier = "SmoothPickerCollectionViewCell"
    internal var itemsWidth = [CGFloat]()
    internal var didEndDragging = true
    internal var itemsCount = 10
    open var isScrollingEnabled = true
    
    internal var scrollView: UIScrollView {
        return sliderCollectionView!
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override  open func layoutSubviews() {
        super.layoutSubviews()
        if !loadedFirstTime {
            commInit()
        }else {
            scrollToItem(index: currentSelectedIndex )
        }
    }
    private func commInit () {
        let firstItemWidth = (dataSource?.itemForIndex(index: 0, pickerView: self).frame.size.width)!
        let contentInsetsLeft  = self.bounds.width / 2 - firstItemWidth / 2
        let lastItemWidth = (dataSource?.itemForIndex(index: (dataSource?.numberOfItems(pickerView: self))! - 1, pickerView: self).frame.size.width)!
        let contentInsetsRight =  self.bounds.width / 2 - (lastItemWidth) / 2
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: contentInsetsLeft  , bottom: 0, right: contentInsetsRight  )
            layout.minimumLineSpacing = 10
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
            return layout
        }()
        sliderCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        sliderCollectionView?.showsHorizontalScrollIndicator = false
        sliderCollectionView?.isScrollEnabled  = isScrollingEnabled
        self.addSubview(sliderCollectionView!)
        sliderCollectionView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview().inset(10)
            maker.centerY.equalToSuperview()
            maker.height.equalTo((dataSource?.itemForIndex(index: 0, pickerView: self).frame.height)! + 20)
        })
        self.sliderCollectionView?.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        self.sliderCollectionView?.register(SmoothPickerCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.sliderCollectionView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        loadedFirstTime = true
        
        self.reloadData()
        
    }
    private func saveFrames() {
        itemsCount = (dataSource?.numberOfItems(pickerView: self))!
        for i in 0..<itemsCount {
            let width  = (dataSource?.itemForIndex(index: i, pickerView: self))!.frame.width
            itemsWidth.append(width)
        }
    }
    public func reloadData(){
        self.saveFrames()
        sliderHandler = SmoothPickerHandler(self)
        if SmoothPickerConfiguration.selectionStyle == nil {
            SmoothPickerConfiguration.setSelectionStyle(selectionStyle: .scale)
        }
        itemsCount = dataSource?.numberOfItems(pickerView: self) ?? 1
        sliderCollectionView?.delegate = self
        sliderCollectionView?.dataSource = self
        self.scrolledFirstTime = false
        self.sliderCollectionView?.reloadData()
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didEndDragging {
            let index = sliderHandler?.indexOfMajorCell() ?? 0
            handleSelection(index: index )
        }
    }
    public func navigate(direction :Direction){
        let toValue = (direction == .next) ? 1 : -1
        self.scrollToItem(index: currentSelectedIndex + toValue )
    }
}
// Mark :CollectionView Delegate
extension SmoothPickerView :UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(pickerView: self) ?? 1
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmoothPickerCollectionViewCell", for: indexPath) as!  SmoothPickerCollectionViewCell
        let item = (dataSource?.itemForIndex(index: indexPath.row, pickerView: self))!
        cell.delegate = delegate
        cell.setContentView(item)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row  == firstselectedItem && !scrolledFirstTime{
            scrolledFirstTime = true
            setSelected(selectedCell: cell,index: indexPath.row)
        }
        if !scrolledFirstTime {
            scrollToItem(index: indexPath.row  + 1)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: itemsWidth[indexPath.row], height: (dataSource?.itemForIndex(index: indexPath.row, pickerView: self).frame.height)!)
        return size
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sliderCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated:currentSelectedCell != nil)
        handleSelection (index:  indexPath.row)
    }
}
// Mark : Paging
extension SmoothPickerView :SmoothPickerScrollDelegate {
    internal func scrollToItem(index:Int ) {
        if index >= 0 && index < itemsCount {
            let indexPath = IndexPath(row: index, section: 0)
            sliderCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated:currentSelectedCell != nil)
            handleSelection (index:  index)
        }
    }
    internal func handleSelection(index:Int) {
        if index >= 0 && index < itemsCount {
            let indexPath = IndexPath(row: index, section: 0)
            if currentSelectedCell !=  nil {
                (currentSelectedCell as? SmoothPickerCollectionViewCell)?.setSelected(selected: false)
            }
            let selectedCell = sliderCollectionView?.cellForItem(at: indexPath)
            if scrolledFirstTime {
                setSelected(selectedCell: selectedCell,index: index)
            }
        }
    }
    internal func setSelected (selectedCell :UICollectionViewCell?,index:Int) {
        currentSelectedCell = selectedCell
        currentSelectedIndex = index
        (selectedCell as? SmoothPickerCollectionViewCell)?.setSelected(selected: true)
        if didEndDragging {
            self.delegate?.didSelectItem(index: index, view:((selectedCell as? SmoothPickerCollectionViewCell)?.view)!, pickerView: self)
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        sliderHandler?.scrollViewWillBeginDragging(scrollView)
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        sliderHandler?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        sliderHandler?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
}

