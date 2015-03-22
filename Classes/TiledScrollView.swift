//
//  TiledScrollView.swift
//  e-motion
//
//  Created by mohamed mohamed El Dehairy on 3/20/15.
//  Copyright (c) 2015 mohamed mohamed El Dehairy. All rights reserved.
//

import UIKit

protocol TiledScrollViewDelegate
{
    /**
    Ask the delegate for the view to be used as a tile at specific x index (from left to right) , and y index (from top to bottom)
    
    :param: xIndex x index of tile (from left to right)
    :param: yIndex y index of tile (from top to bottom)
    :param: frame  the frame of the tile
    
    :returns: returns the tile view at the specified xIndex , and yIndex
    */
    func viewForTileAtIndex(xIndex : Int , yIndex : Int , frame : CGRect)-> UIView;
}

class TiledScrollView: UIScrollView  {
    
    
    private var visibleViews : LinkedList<LinkedList<UIView>> = LinkedList<LinkedList<UIView>>();
    private var containerView : UIView!;
    
    
    var tilingDelegate : TiledScrollViewDelegate?;
    
    init(frame: CGRect , contentSize : CGSize , tiledDelegate : TiledScrollViewDelegate?) {
        
        super.init(frame: frame)
        
        self.contentSize = contentSize;
        
        self.tilingDelegate = tiledDelegate;
        
        self.initialiseUI(frame);
    }
    
    convenience override init(frame: CGRect) {
        
        self.init(frame: frame , contentSize : frame.size , tiledDelegate : nil)
        
        self.initialiseUI(frame);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        self.initialiseUI(self.frame);
    }
    
    private func initialiseUI(frame : CGRect)
    {
        
        containerView = UIView(frame: CGRectMake(0, 0, frame.size.width, self.contentSize.height));
        self.addSubview(containerView);
        
        visibleViews.appendObjectToHead(LinkedList<UIView>());
        
        let newView = self.createView(CGRectMake(0, 0, frame.size.width, frame.size.height) , xIndex : 0 , yIndex : 0)
        containerView.addSubview(newView)
        visibleViews.getTail()?.appendObjectToTail(newView);
        
        
    }
    
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        let boundRect = self.convertRect(self.bounds, toView: self.containerView);
        
        // add/remove tiles horizontall*****************************************************
        for array in visibleViews
        {
            
            //add views at the bottom
            var view : UIView! = array.getTail()!;
            var maxY = CGRectGetMaxY(view.frame);
            
            while maxY < CGRectGetMaxY(boundRect)
            {
                let yPosition = view.frame.origin.y + view.frame.size.height;
                let xPosition = view.frame.origin.x;
                
                let newView = self.createView(CGRectMake(xPosition, yPosition , frame.size.width, frame.size.height) , xIndex : Int(CGFloat(xPosition) / view.frame.size.width) ,yIndex : Int(CGFloat(yPosition) / view.frame.size.height))
                containerView.addSubview(newView);
                array.appendObjectToTail(newView);
                
                
                view = array.getTail()!;
                maxY  = CGRectGetMaxY(view.frame);
            }
            
            
            
            //add views at the top
            view = array.getHead()!;
            var minY  = CGRectGetMinY(view.frame);
            
            while minY > CGRectGetMinY(boundRect)
            {
                let yPosition = view.frame.origin.y - view.frame.size.height;
                let xPosition = view.frame.origin.x;
                
                let newView = self.createView(CGRectMake(xPosition, yPosition , frame.size.width, frame.size.height) , xIndex : Int(CGFloat(xPosition) / view.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view.frame.size.height))
                containerView.addSubview(newView);
                array.appendObjectToHead(newView);
                
                view = array.getHead()!;
                minY = CGRectGetMinY(view.frame);
                
            }
            
        
        
        
            //remove views that has fallen beyond the bottom edge
            view = array.getTail()?;
            minY  = CGRectGetMinY(view.frame)
            
            while minY > CGRectGetMaxY(boundRect)
            {
                view.removeFromSuperview();
                array.removeFromTail();
                
                
                view = array.getTail()?;
                minY = CGRectGetMinY(view.frame)
                
            }

        
        
            //remove views that has fallen beyond the top edge
            view = array.getHead()?;
            maxY  = CGRectGetMaxY(view.frame);
            
            while maxY < CGRectGetMinY(boundRect)
            {
                view.removeFromSuperview();
                array.removeFromHead();
                
                view = array.getHead()?;
                maxY  = CGRectGetMaxY(view.frame);
                
            }
            
        }
        
        
        
        // add/remove tiles vertically*****************************************************
        
        //add views at the right
        var view2 = visibleViews.getTail()!.getHead()!;
        var maxX = CGRectGetMaxX(view2.frame);
        
        while maxX < CGRectGetMaxX(boundRect)
        {
            var newArray = LinkedList<UIView>();
            
            for var index = 0 ; index < visibleViews.getTail()?.count ; index++
            {
                let xPosition = view2.frame.origin.x + view2.frame.size.width;
                let yPosition = view2.frame.origin.y + CGFloat(index) * view2.frame.size.height;
                
                let newView = self.createView(CGRectMake(xPosition , yPosition, frame.size.width, frame.size.height) , xIndex : Int(CGFloat(xPosition) / view2.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view2.frame.size.height))
                containerView.addSubview(newView);
                newArray.appendObjectToTail(newView);
                
            }
            
            visibleViews.appendObjectToTail(newArray);
            
            view2 = visibleViews.getTail()!.getHead()!;
            maxX  = CGRectGetMaxX(view2.frame);
            
        }
        
        
        
        
        //add views at the left
        var view1 : UIView! = visibleViews.getHead()?.getHead()?;
        var minX  = CGRectGetMinX(view1.frame);
        
        while minX > CGRectGetMinX(boundRect)
        {
            var newArray = LinkedList<UIView>();
            
            for var index = 0 ; index < visibleViews.getHead()?.count ; index++
            {
                let xPosition = view1.frame.origin.x - view1.frame.size.width;
                let yPosition = view1.frame.origin.y + CGFloat(index) * view1.frame.size.height;
                
                let newView = self.createView(CGRectMake(xPosition, yPosition, frame.size.width, frame.size.height) , xIndex : Int(CGFloat(xPosition) / view2.frame.size.width) , yIndex : Int(CGFloat(yPosition) / view1.frame.size.height))
                containerView.addSubview(newView);
                newArray.appendObjectToTail(newView);
            }
            
            visibleViews.appendObjectToHead(newArray);
            
            view1 = visibleViews.getHead()?.getHead()?;
            minX  = CGRectGetMinX(view1.frame);
            
        }
        
        
        
        
        //remove views that has fallen beyond the right edge
        view2 = visibleViews.getTail()!.getHead()!;
        minX  = CGRectGetMinX(view2.frame)
        
        while minX > CGRectGetMaxX(boundRect)
        {
            
            for view in visibleViews.getTail()!
            {
                view.removeFromSuperview();
            }
            
            visibleViews.removeFromTail();
            
            view2 = visibleViews.getTail()!.getHead()!;
            minX  = CGRectGetMinX(view2.frame)
            
        }
        
        
        
        //remove views that has fallen beyond the left edge
        view1 = visibleViews.getHead()!.getHead()!;
        maxX  = CGRectGetMaxX(view1.frame);
        
        while maxX < CGRectGetMinX(boundRect)
        {
            
            for view in visibleViews.getHead()!
            {
                view.removeFromSuperview();
            }
            
            visibleViews.removeFromHead();
            
            
            view1 = visibleViews.getHead()!.getHead()!;
            maxX  = CGRectGetMaxX(view1.frame);
            
        }
        
        
        
    }
    
    private func createView( frame : CGRect , xIndex : Int , yIndex : Int)-> UIView
    {
        
        if(tilingDelegate != nil)
        {
            let tileView = tilingDelegate!.viewForTileAtIndex(xIndex , yIndex: yIndex , frame : frame);
            tileView.frame = frame;
            return tileView;
            
        }else
        {
            return UIView(frame: frame);
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */


}
