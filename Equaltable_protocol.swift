//
//  Equaltable protocol.swift
//
//  “==” 是一个操作符，Equaltabel里声明了这个操作符的接口方法
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 15/01/2016
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit
import Foundation

protocol Equaltable{

	func ==(lhs: String, rhs: String) -> Bool

}

//让TodoItem 类实现 Equaltable 接口

class TodoItem{

	let uuid: String
	var tittle: String

	init(uuid: String, tittle: String){

		self.uuid = uuid
		self.tittle = tittle

	}

}

// TodoItem 实现接口，拓展 TodoItem类
extension TodoItem: Equaltable{

}

//把 == 实现并没有放在对应的extension 里面，而是放在了全局的scope中
//让全局范围内都能使用 == 。
func ==(lhs: TodoItem, rhs: TodoItem) -> Bool{

	return lhs.uuid == rhs.uuid

}