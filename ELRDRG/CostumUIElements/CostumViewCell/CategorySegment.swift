import UIKit

class CategorySegmentedControl: UISegmentedControl {
    
    
    var sortedViews: [UIView]!
    var currentIndex: Int = -1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    
    
    private func configure() {
        for view in self.subviews {
            view.backgroundColor = UIColor.clear
        }
       // sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        currentIndex = 0
        for view in self.subviews
        {
                      if(currentIndex == 0)
                       {
                           view.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                       }
                       else if(currentIndex == 1)
                       {
                           view.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
                       }
                       else if(currentIndex == 2)
                       {
                           view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
                       }
                       else if(currentIndex == 3)
                       {
                           view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                       }
                       else if(currentIndex == 4)
                       {
                           view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                       }
                       currentIndex = currentIndex + 1
        }
        currentIndex = -1
        
      
        
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        self.alpha = 1.0
        sortedViews = self.subviews//.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        var index : Int = 0
        for subview in sortedViews {
            
            if(index == newIndex)
            {
                if(index == 0)
                {
                    if #available(iOS 13.0, *) {
                        self.selectedSegmentTintColor = UIColor.red.withAlphaComponent(1)
                    } else {
                        subview.tintColor = UIColor.red.withAlphaComponent(1)
                    }
                    subview.backgroundColor = UIColor.red.withAlphaComponent(1)
                    
                }
                else if(index == 1)
                {
                    if #available(iOS 13.0, *) {
                       self.selectedSegmentTintColor = UIColor.orange.withAlphaComponent(1)
                   }
                    subview.backgroundColor = UIColor.orange.withAlphaComponent(1)
                }
                else if(index == 2)
                {
                    if #available(iOS 13.0, *) {
                        self.selectedSegmentTintColor = UIColor.green.withAlphaComponent(1)
                                      }
                    subview.backgroundColor = UIColor.green.withAlphaComponent(1)
                }
                else if(index == 3)
                {
                    if #available(iOS 13.0, *) {
                                          self.selectedSegmentTintColor = UIColor.white.withAlphaComponent(1)
                                      }
                    subview.backgroundColor = UIColor.white.withAlphaComponent(1)
                }
                else if(index == 4)
                {
                    if #available(iOS 13.0, *) {
                                          self.selectedSegmentTintColor = UIColor.white.withAlphaComponent(1)
                                      }
                    subview.backgroundColor = UIColor.white.withAlphaComponent(1)
                }
            }
            else
            {
                subview.backgroundColor = subview.backgroundColor?.withAlphaComponent(0.1)
            }
            index = index + 1
        }
        if(currentIndex != -1)
        {
            sortedViews[currentIndex].layer.borderWidth = 0
            
            if(currentIndex == 0)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.1)
                
            }
            else if(currentIndex == 1)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.1)
                
            }
            else if(currentIndex == 2)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.1)
                
            }
            else if(currentIndex == 3)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.1)
                
            }
            else if(currentIndex == 4)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.1)
                
            }
            
        }
         
        currentIndex = newIndex
        if(newIndex == -2)
        {
            currentIndex = 3
        }
        else if(newIndex != -2 && newIndex < 0)
        {
            return
        }
        
       
        sortedViews[currentIndex].layer.borderWidth = 0
        
        if(currentIndex != 4)
        {
            let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.setTitleTextAttributes(titleTextAttributes, for: .normal)
            self.setTitleTextAttributes(titleTextAttributes, for: .selected)
        }
        else
        {
            let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            self.setTitleTextAttributes(titleTextAttributes, for: .normal)
            self.setTitleTextAttributes(titleTextAttributes, for: .selected)
        }
        
        
        if(currentIndex == 3 || currentIndex == 4)
        {
            sortedViews[currentIndex].backgroundColor = UIColor.blue.withAlphaComponent(1)
            if #available(iOS 13.0, *) {
                self.selectedSegmentTintColor = UIColor.blue.withAlphaComponent(1)
            }
            
        }
        else
        {
            sortedViews[currentIndex].backgroundColor = sortedViews[currentIndex].backgroundColor?.withAlphaComponent(1)
        }
 
        
    }
}
