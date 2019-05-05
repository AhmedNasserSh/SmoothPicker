//
//  CustomizeYourGiftsGiftCollectionViewCell.swift
//  Ana Vodafone
//
//  Created by Ahmed Nasser on 1/16/19.
//  Copyright © 2019 Vodafone Egypt. All rights reserved.
//

import UIKit

class CustomizeYourGiftSliderItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var giftValueLabel: UILabel!
    var value : String?
    private var color : UIColor?
    var loadFirstTime = false
    var selected:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    private func nibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    func setData(value:String) {
        self.value = value
        self.giftValueLabel.text = value
    }
    func setLabelColor(_ color :UIColor,newValue:String?){
        self.color = color
        if giftValueLabel != nil {
            self.giftValueLabel.textColor = color
        }
    }
    override func setSmoothSelected(_ selected: Bool) {
        self.selected = selected
        self.color = selected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8406969905, green: 0.8407167792, blue: 0.8407061696, alpha: 1)
        loadFirstTime = true
        if giftValueLabel != nil {
            self.giftValueLabel.textColor = color
        }
    }
}
