//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/03/02.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    private let memoEntityName = "Memo"
    var memoList: [NSManagedObject] = []
    var count: Int {
        return memoList.count
    }
    
    func note(index: Int) -> NSManagedObject? {
        guard memoList.count > index, index >= 0 else {
            return nil
        }
        
        return memoList[index]
    }
    
    func saveMemo(title: String, body: String) {
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: memoEntityName, in: context) {
            let memo = NSManagedObject(entity: entity, insertInto: context)
            memo.setValue(title, forKey: "title")
            memo.setValue(body, forKey: "body")
            memo.setValue(Date(), forKey: "lastModifiedDate")
            
            do {
                try context.save()
                memoList.insert(memo, at: 0)
            } catch {
                print(error.localizedDescription)
                context.rollback()
            }
        }
    }
    
    func fetchMemo() {
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: memoEntityName)
            
            do {
                memoList = try context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMemo(object: NSManagedObject) {
        if let context = context{
            context.delete(object)
            
            do {
                try context.save()
                fetchMemo()
//                NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateMemo(object: NSManagedObject, title: String, body: String) {
        if let context = context{
            object.setValue(title, forKey: "title")
            object.setValue(body, forKey: "body")
            object.setValue(Date(), forKey: "lastModifiedDate")
            
            do {
                try context.save()
                fetchMemo()
//                NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
            } catch {
                print(error.localizedDescription)
                context.rollback()
            }
        }
    }
}
