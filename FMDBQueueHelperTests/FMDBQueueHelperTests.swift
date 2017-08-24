//
//  FMDBQueueHelperTests.swift
//  FMDBQueueHelperTests
//
//  Created by 安丹阳 on 2017/8/23.
//  Copyright © 2017年 an. All rights reserved.
//

import XCTest
@testable import FMDBQueueHelper

class FMDBQueueHelperTests: XCTestCase {
    
    var cache: NetCache!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        NetCache.creatTable()
        cache = NetCache.init(userId: "0002", key: "Key001", url: "http://www.baidu.com", data: Data(bytes: [0x01, 0x02, 0x03, 0x06]), date: Date())
        cache.save()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        NetCache.select(userId: "0003", key: "Key005") { (cache) in
            
            print(cache?.description ?? "")
        }
    }
    
    func testPerformanceExample() {
       
        self.measure {
            NetCache.init(userId: "0003", key: "Key005", url: "http://www.baidu.com", data: Data(bytes: [0x01, 0x02, 0x03, 0x06]), date: Date()).save()
        }
    }
    
}
