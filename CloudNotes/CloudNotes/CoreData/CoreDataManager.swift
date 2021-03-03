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
    var memoList: [Memo] = []
    var count: Int {
        return memoList.count
    }
    
    func note(index: Int) -> Memo? {
        guard memoList.count > index, index >= 0 else {
            return nil
        }
        
        return memoList[index]
    }

    func saveMemo(title: String, body: String) -> Memo? {
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: memoEntityName, in: context) {
            let memo = Memo(entity: entity, insertInto: context)
            memo.setValue(title, forKey: "title")
            memo.setValue(body, forKey: "body")
            memo.setValue(Date(), forKey: "lastModifiedDate")
            
            do {
                try context.save()
                memoList.append(memo)
            } catch {
                print(error.localizedDescription)
                context.rollback()
            }
            return memo
        }
        return nil
    }
    
    func fetchMemo() {
        if let context = context {
            let request = NSFetchRequest<Memo>(entityName: memoEntityName)
            
            do {
                memoList = try context.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(memo: Memo) {
        if let context = context{
            context.delete(memo)
            
            do {
                try context.save()
                fetchMemo()
                NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(memo: Memo, title: String, body: String) {
        if let context = context{
            memo.title = title
            memo.body = body
            memo.lastModifiedDate = Date()
            
            do {
                try context.save()
                fetchMemo()
                NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
            } catch {
                print(error.localizedDescription)
                context.rollback()
            }
        }
    }
}
