//
//  LinkedListNode.swift
//  e-motion
//
//  Created by mohamed mohamed El Dehairy on 3/21/15.
//  Copyright (c) 2015 mohamed mohamed El Dehairy. All rights reserved.
//

import UIKit

class LinkedListNode<T> {
    
    var object   : T;
    var nextNode : LinkedListNode<T>?;
    var preNode  : LinkedListNode<T>?;
    
    init(object : T)
    {
        self.object = object;
    }
   
}
