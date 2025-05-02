//
//  UserEntity+CoreDataProperties.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?

}

extension UserEntity : Identifiable {

}
