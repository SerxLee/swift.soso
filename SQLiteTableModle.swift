//
//  SQLiteTableModle.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 2016-01-25 20:17:27
//  Copyright © 2016 serx. All rights reserved.
//

/*
  	a Modle for the SQLite,
  	just define the var what you want
*/

import Foundation

class Girl: NSObject {
    
    var id: Int =  0
    var name: String?
    var age: Int = 0
    var height: Double = 0
    
    //重写字典转模型
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    //生成插入sql语句
    lazy var getInsertSql: String = {
        assert(self.name != nil ,"姓名不能为空")
        let sql: String = "insert into Girls(name , age, height)\n" + "VALUES('\(self.name!)', \(self.age), \(self.height));"
        return sql
    }()
    
    //生成删除sql语句
    lazy var getDelecSql: String = {
        assert( self.id > 0 , "ID不正确")
        let sql: String = "DELETE FROM Girls where id = \(self.id)"
        return sql
    }()
    
    //生成更新sql语句
    lazy var getUpdateSql: String = {
        assert(self.name != nil, "姓名不能为空")
        assert(self.id > 0, "id 不正确")
        let sql: String = "update Girls set name = '\(self.name!)' ,age =\(self.age) , height =\(self.height);"
        return sql
    }()
}