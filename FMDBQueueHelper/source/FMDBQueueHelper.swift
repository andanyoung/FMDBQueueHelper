//
//  DBManage.swift
//  healthy
//
//  Created by 安丹阳 on 2017/8/4.
//  Copyright © 2017年 massagechair. All rights reserved.
//

import UIKit



open class FMDBQueueHelper: NSObject {
    
    public typealias FMInDatabaseBlock = (FMDatabase)-> Void
    
    public typealias FMInTransactionBlock = (FMDatabase, UnsafeMutablePointer<ObjCBool>)-> Void
    
    ///数据库目录默认在DocumentDirectory下
    open var path: String =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    open var dbName = "DEFAULT"
    
    
    fileprivate var queue: FMDatabaseQueue!
    
    fileprivate var db: FMDatabase!
    
    fileprivate static let ShareInstance = FMDBQueueHelper()
    
    
    /// 一个单列。会根据dbname 来执行相应的数据库
    /// 若dbname 与上一次传入的不同，则关闭上一次的数据库，打开新的数据库，
    ///否则（或为nil）返回上一次的数据库
    /// - Parameter dbname: 数据库名字
    /// - Returns: FMDBQueueHelper 实例
    open static func share( _ dbname: String? = nil ) -> FMDBQueueHelper {
        
        if let dbname = dbname,
            ShareInstance.dbName != dbname{
            
            ShareInstance.openDB(dbName: dbname)
        }else{
            if  ShareInstance.queue == nil{
                ShareInstance.openDB(dbName: ShareInstance.dbName)
            }
            //ShareInstance.queue
        }
        
        return ShareInstance
    }
    
    //异步执行Update
    open func sync_executeUpdate(sql: String, withArgumentsIn:[Any] = [], complete: ((Bool)->Void)? = nil) {
        
        queue.inDatabase { (db) in
            let result = db.executeUpdate(sql, withArgumentsIn: withArgumentsIn)
            complete?(result)
            #if DEBUG
                print("\n-----DEBUG sql----\n sync_executeUpdate SQL:" + sql)
                print("result : \(result) err: \(db.lastError())")
            #endif
        }
    }
    
    //异步Query
    open func sync_executeQuery(sql: String, withArgumentsIn:[Any] = [], complete: ((FMResultSet?)->Void)? = nil) {
        
        queue.inDatabase { (db) in
            let result = db.executeQuery(sql, withArgumentsIn: withArgumentsIn)
            complete?( result )
            #if DEBUG
                print("\n-----DEBUG sql----\n sync_executeQuery SQL:" + sql)
                print("result : \(String(describing: result)) err: \(db.lastError())")
            #endif
        }
    }
    
    //同步update
    @discardableResult
    open func executeUpdate(sql: String, withArgumentsIn:[Any] = []) -> Bool {
        
        
        return db.executeUpdate(sql, withArgumentsIn: withArgumentsIn)
    }
    
    //同步update
    @discardableResult
    open func executeQuery(sql: String, withArgumentsIn:[Any] = []) -> FMResultSet? {
        
        
        return db.executeQuery(sql, withArgumentsIn: withArgumentsIn)
    }
    
    
    
    ///异步执行
    open func inDatabase(block: FMInDatabaseBlock)  {
        
        queue.inDatabase(block)
    }
    
    ///异步事务
    open func inTransaction(block: FMInTransactionBlock) {
        
        queue.inTransaction(block)
    }
    
    ///打开当前数据库
    open func openDB( dbName: String)  {
        
        close()
        self.dbName = dbName
        queue = FMDatabaseQueue(path: self.path + "/" + self.dbName + ".db")
        db = queue.value(forKey: "_db") as! FMDatabase
        #if DEBUG
            print("openDB databasePath" + (db.databasePath ?? " is nil"))
        #endif
        
    }
    
    /// 关闭当前数据库
    open func close()  {
        
        dbName = ""
        
        if let queue = self.queue {
            queue.close()
            db = nil
            //queue.openFlags = 0
        }
        
    }
}
