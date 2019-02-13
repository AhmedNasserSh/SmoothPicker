//
//  ViewController.swift
//  SmoothPicker
//
//  Created by ahmed.nasser2310@gmail.com on 02/11/2019.
//  Copyright (c) 2019 ahmed.nasser2310@gmail.com. All rights reserved.
//

import UIKit
import SmoothPicker
class ViewController: UIViewController,SmoothPickerViewDelegate,SmoothPickerViewDataSource {
    @IBOutlet weak var pickerView: SmoothPickerView!
    
    var i = 0
    var views = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        SmoothPickerConfiguration.setSelectionStyle(selectionStyle: .colored)
        for _ in 1..<11 {
            i += 5
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            views.append(view)
        }
    }
    func didSelectIndex(index: Int) {
        print("SelectedIndex \(index)")
    }
    
    func numberOfItems() -> Int {
        return 10
    }
    
    func itemForIndex(index: Int) -> UIView {
        return views[index]
    }
    @IBAction func navigateNext(_ sender: Any) {
        pickerView.navigate(direction: .next)
    }
    @IBAction func navigatePervious(_ sender: Any) {
        pickerView.navigate(direction: .pervious)
    }
    
}

