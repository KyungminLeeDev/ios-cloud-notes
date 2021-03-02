//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/03/02.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var lastModifiedDate: Date?

}

extension Memo : Identifiable {

}
