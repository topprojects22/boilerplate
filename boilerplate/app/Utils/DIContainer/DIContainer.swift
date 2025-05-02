//
//  DIContainer.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import CoreData

class DIContainer {
    static let shared = DIContainer()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "UserModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error $error.userInfo)")
            }
        }
    }
    
    func makeUserRepository() -> UserRepository {
        let networkService = UserNetworkService()
        let localStore = UserLocalStore(container: persistentContainer)
        return UserRepositoryImpl(networkService: networkService, localStore: localStore)
    }
}
