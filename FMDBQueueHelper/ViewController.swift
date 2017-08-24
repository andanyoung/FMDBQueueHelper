//
//  ViewController.swift
//  FMDBQueueHelper
//
//  Created by 安丹阳 on 2017/8/23.
//  Copyright © 2017年 an. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NetCache.creatTable()
        let cache = NetCache.init(userId: "0002", key: "Key001", url: "http://www.baidu.com", data: Data(bytes: [0x01, 0x02, 0x03, 0x06]), date: Date())
        cache.save()
        
        NetCache.init(userId: "0003", key: "Key005", url: "http://www.baidu.com", data: Data(bytes: [0x01, 0x02, 0x03, 0x06]), date: Date()).save()
        
        NetCache.select(userId: "0003", key: "Key005") { (cache) in
            
            print(cache?.description ?? "")
        }
    }

    
  
}

