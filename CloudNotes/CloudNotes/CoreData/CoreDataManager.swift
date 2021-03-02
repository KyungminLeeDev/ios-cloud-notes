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
}
