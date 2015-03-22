//
//  ViewController.swift
//  MDTiledScrollView Demo
//
//  Created by mohamed mohamed El Dehairy on 3/22/15.
//  Copyright (c) 2015 mohamed mohamed El Dehairy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,TiledScrollViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0);
        
        let tiledScrollView = TiledScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), contentSize: CGSize(width: 10000, height: 10000), tiledDelegate: self);
        tiledScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
        
        self.view.addSubview(tiledScrollView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForTileAtIndex(xIndex: Int , yIndex : Int, frame: CGRect) -> UIView
    {
        
        let newView = UIView(frame: frame);
        
        if(xIndex % 2 == 0)
        {
            if(yIndex % 2 == 0)
            {
                newView.backgroundColor = UIColor.greenColor();
            }else
            {
                newView.backgroundColor = UIColor.redColor();
            }
        }else
        {
            if(yIndex % 2 == 0)
            {
                newView.backgroundColor = UIColor.redColor();
            }else
            {
                newView.backgroundColor = UIColor.greenColor();
            }
        }
        
        return newView;
    }


}

