//
//  NetCache.swift
//  healthy
//
//  Created by 安丹阳 on 2017/8/11.
//  Copyright © 2017年 massagechair. All rights reserved.
//

import UIKit


let G_yMdHms_DateFormatter : DateFormatter = {
    $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return $0
}(DateFormatter())

struct NetCache {

    
    var userId: String
    
    var key: String
    
    var url: String
    
    var data: Data?
    
    var date: Date
    
    
    static func creatTable()  {
        let sql = "CREATE TABLE if not exists \"NetCache\" ( \"userId\" TEXT NOT NULL, \"key\" TEXT NOT NULL, \"url\" TEXT NOT NULL, \"data\" blob, \"date\" DATETIME NOT NULL DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime')), PRIMARY KEY(\"userId\",\"key\"), CONSTRAINT \"user\" FOREIGN KEY (\"userId\") REFERENCES \"Users\" (\"userId\") ON DELETE CASCADE )"
        FMDBQueueHelper.share().sync_executeUpdate(sql: sql)
    }
    
    func save(){
        let sql = "replace into \"NetCache\" (\"userId\",  \"key\", \"url\", \"data\", \"date\") values ( ?, ?, ?, ?, (datetime(CURRENT_TIMESTAMP,'localtime')))"
        FMDBQueueHelper.share().sync_executeUpdate(sql: sql, withArgumentsIn: [userId, key, url, data ?? Data()], complete: nil)
        
    }

    
    static func select(userId: String, key: String, completionHandler:@escaping (NetCache?)->Void)  {
        
        let sql = "select * from 'NetCache' where userId = '\(userId)' and key = '\(key)' LIMIT 1"
        FMDBQueueHelper.share().sync_executeQuery(sql: sql) { (set) in
            
            if let set = set{
                set.next()
                completionHandler(NetCache(resultSet: set))
                set.close()
            }else{
                completionHandler(nil)
            }
            
        }
        
    }
    
    fileprivate init?( resultSet: FMResultSet) {
        
        userId = resultSet.string(forColumn: "userid") ?? ""
        key = resultSet.string(forColumnIndex: 1) ?? ""
        url = resultSet.string(forColumnIndex: 2) ?? ""
        data = resultSet.data(forColumnIndex: 3)
        date =  G_yMdHms_DateFormatter.date(from: resultSet.string(forColumnIndex: 4) ?? "") ?? Date()
        if userId.isEmpty {
            return nil
        }
    }
    
    init(userId: String =  "", key: String,  url: String,  data: Data?,  date: Date = Date()) {
        
        self.userId = userId
        self.key = key
        self.url = url
        self.date = date
        self.data = data
    }
    
}

extension NetCache : CustomStringConvertible{
    
    var description: String{
        return "userId: \(userId)\n" +
        "key: \(key)\n" +
        "url: \(url) \n" +
        "date: \(date) \n" +
        "data: \( data as? NSData) \n"
    }
}


