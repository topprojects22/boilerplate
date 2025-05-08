//
//  UserLocalStore.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//


// MARK: - Data/Local/UserLocalStore.swift
import CoreData

class UserLocalStore {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Сохранить/обновить пользователя
    func save(user: User) {
        let context = container.viewContext
        let entity = UserEntity(context: context)
        entity.id = Int64(user.id)
        entity.name = user.name
        entity.isFavorite = user.isFavorite
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: $error)")
        }
    }
    
    // Получить всех пользователей
    func fetchAll() -> [User] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let entities = try container.viewContext.fetch(request)
            return entities.map { 
                User(id: Int($0.id), name: $0.name ?? "Unknown", email: "email@example.com", isFavorite: $0.isFavorite) 
            }
        } catch {
            return []
        }
    }
}
