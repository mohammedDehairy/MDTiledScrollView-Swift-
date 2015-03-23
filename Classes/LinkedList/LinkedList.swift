//
//  LinkedList.swift
//  e-motion
//
//  Created by mohamed mohamed El Dehairy on 3/21/15.
//  Copyright (c) 2015 mohamed mohamed El Dehairy. All rights reserved.
//

import UIKit

class LinkedList<T> : SequenceType {
    
    private var head : LinkedListNode<T>?;
    private var tail : LinkedListNode<T>?;
    
    private var iteratorCurrentObject : LinkedListNode<T>?;
    
    var count : Int;
   
    init()
    {
        count = 0;
    }
    
    func getTail()->T?
    {
        return tail?.object;
    }
    
    func getHead()->T?
    {
        return head?.object;
    }
    
    func appendObjectToTail(object : T)
    {
        let newNode = LinkedListNode<T>(object: object);
        
        if(tail == nil)
        {
            head = newNode;
            tail = newNode;
        }else
        {
            tail?.nextNode  = newNode;
            newNode.preNode = tail;
            tail            = newNode;
        }
        
        count++;
    }
    
    func appendObjectToHead(object : T)
    {
        let newNode = LinkedListNode<T>(object: object);
        
        if(head == nil)
        {
            head = newNode;
            tail = newNode;
        }else
        {
            newNode.nextNode = head;
            head?.preNode    = newNode;
            head             = newNode;
        }
        
        count++;
    }
    
    func removeFromHead()->T?
    {
        let object = head?.object;
        
        head?.nextNode?.preNode = nil;
        
        head = head?.nextNode;
        
        count--;
        
        return object;
    }
    
    func removeFromTail()->T?
    {
        let object = tail?.object;
        
        tail?.preNode?.nextNode = nil;
        
        tail = tail?.preNode;
        
        count--;
        
        return object;
    }
    
    
    func generate() -> GeneratorOf<T> {
        
        iteratorCurrentObject = nil;
        
        return GeneratorOf<T>{
        
            if(self.iteratorCurrentObject == nil)
            {
                self.iteratorCurrentObject = self.head;
            }else
            {
                self.iteratorCurrentObject = self.iteratorCurrentObject?.nextNode;
            }
            
            return self.iteratorCurrentObject?.object;
        
        }
    }
    
}
