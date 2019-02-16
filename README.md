# SmoothPicker
[![Version](https://img.shields.io/cocoapods/v/SmoothPicker.svg?style=flat)](https://cocoapods.org/pods/SmoothPicker)
[![License](https://img.shields.io/cocoapods/l/SmoothPicker.svg?style=flat)](https://cocoapods.org/pods/SmoothPicker)
[![Platform](https://img.shields.io/cocoapods/p/SmoothPicker.svg?style=flat)](https://cocoapods.org/pods/SmoothPicker)

A Customized Component for creating a horizontal iOS picker with custom views 


![Alt Text](https://media.giphy.com/media/45bEffMoHH5UzskrgJ/giphy.gif) 
![Alt Text](https://media.giphy.com/media/m7X4g645AFmLcrfFBa/giphy.gif)
![Alt Text](https://media.giphy.com/media/8c0YArRpDDAC8o59oc/giphy.gif)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

SmoothPicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SmoothPicker'
```

# Usage

Create the view either by storyboard or by frame 
<br />

```
class ViewController{
   @IBOutlet weak var pickerView: SmoothPickerView!
    
    var i = 0
    var views = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1..<11 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            view.backgroundColor = UIColor.gray
            views.append(view)
        }
        
        pickerView.firstselectedItem = 2 // you can also set the first selected item at launch 

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
```

## Data Source
```
func numberOfItems() -> Int //number of items to display
func itemForIndex(index:Int) -> UIView // retrun the view per item just make sure it can calculate it's frame correctly 
```
## Delegate
```
 func didSelectIndex(index:Int,view:UIView) // the selected item  
```
## Navigation
```
//The default navigation is swipe you can in addtion set navigation to some button 
public enum Direction {
    case  next
    case  pervious
}
public func navigate(direction :Direction)
```
## Selection
```
open var firstselectedItem = 0 // to set the first selected item at intilization 0 is the default 
```


## Customization
![Alt Text](https://media.giphy.com/media/4HcSMGzEB59kdyNcIU/giphy.gif)
```
// you can choose between the selection styles available 
// a new styles and layouts are upcoming 
public enum SelectionStyle {
    case scale
    case colored
}
SmoothPickerConfiguration.setSelectionStyle(selectionStyle: .scale) // scale is deafult default 
static func setColors(selectedColor:UIColor,dimmedColor:UIColor) // for colred selection style black and gray is default
@objc open func setSmoothSelected(_ selected : Bool) // you can ovveride it in your view it gives you the. current state of your view 
```

## Authors

* **Ahmed Nasser** - [AvaVaas](https://github.com/AvaVaas)

## License

SmoothPicker is available under the MIT license. See the LICENSE file for more info.

thanks for this tutorial it was a great help 
https://medium.com/@shaibalassiano/tutorial-horizontal-uicollectionview-with-paging-9421b479ee94
