//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Serx on 1/1/16.
//  Copyright © 2016 Razeware. All rights reserved.
//


import CoreData

class CoreDataStack {
    
    let modelName = "Dog Walk"
    
    //文件路径 URL
    
    private lazy var applciationDocumentDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
                NSSearchPathDirectory.DocumentDirectory,
                inDomains: NSSearchPathDomainMask.UserDomainMask)
        return urls[urls.count - 1] as NSURL
    }()

    //NSManagedObjectContext
    //Note: ConcurrencyType 的具体参数会在后面补充添加，暂时先使用 .MainQueueConcurrencyType
    //创建出来Context是完全没有意义的，直到设置了Context的PersistentStoreCoordinator
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    //NSPersistentStoreCoordinator
    //对StoreCoordinator做懒加载，StoreCoordinator是介与PersistentStore(s)和ObejctModel之间的，所以至少需要一个PersistentStore。
    private lazy var psc: NSPersistentStoreCoordinator = {
        //coordinator init，传入Model，Model指所有的Entity和所有的relationship
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //    PersisitentStore 的物理存储路径
        let url = self.applciationDocumentDirectory.URLByAppendingPathComponent(self.modelName)
        do{
            //      一些Option配置：
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            //addPersistentStoreWithType 选择一个SQLite的type，使用SQLite作为存储模式。
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL:url, options: options)
        } catch {
            print("Error adding persistnet store.")
        }
        return coordinator
    }()
    
    //NSManagedObjectModel
    //这里包含着MainBundle里面的momb文件里面的 `.xcdatamodeld` 文件，就是Xcode图形化设计Entity和Relationship的那个文件，使用它来创建ManagedObjectModel
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    func saveContent(){
        if context.hasChanges{
            do{
                try context.save()
            }catch let error as NSError{
                print("Error:\(error.localizedDescription)")
                abort()
            }
        }
    }
}
