import UIKit

class CategorySegmentedControl: UISegmentedControl {
    
    
    var sortedViews: [UIView]!
    var currentIndex: Int = -1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    
    
    private func configure() {
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
        
        
        
        while currentIndex < self.sortedViews.count {
            if(currentIndex == 0)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
            else if(currentIndex == 1)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.orange.withAlphaComponent(0.2)
            }
            else if(currentIndex == 2)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.green.withAlphaComponent(0.2)
            }
            else if(currentIndex == 3)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
            else if(currentIndex == 4)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
            currentIndex = currentIndex + 1
        }
        currentIndex = -1
        
    }
    
    func changeSelectedIndex(to newIndex: Int) {
        
        self.selectedSegmentIndex = UISegmentedControlNoSegment
        sortedViews = self.subviews.sorted(by:{$0.frame.origin.x < $1.frame.origin.x})
    
        if(currentIndex != -1)
        {
            sortedViews[currentIndex].layer.borderWidth = 0
           
            
            
            if(currentIndex == 0)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.red.withAlphaComponent(0.2)
                
            }
            else if(currentIndex == 1)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.orange.withAlphaComponent(0.2)
                
            }
            else if(currentIndex == 2)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.green.withAlphaComponent(0.2)
                
            }
            else if(currentIndex == 3)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.2)
                
            }
            else if(currentIndex == 4)
            {
                sortedViews[currentIndex].backgroundColor = UIColor.white.withAlphaComponent(0.2)
                
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
        
        
        sortedViews[currentIndex].layer.borderWidth = 3
        
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
            sortedViews[currentIndex].backgroundColor = UIColor.blue
        }
        else
        {
            sortedViews[currentIndex].backgroundColor = sortedViews[currentIndex].backgroundColor?.withAlphaComponent(1)
        }
        
    }
}
