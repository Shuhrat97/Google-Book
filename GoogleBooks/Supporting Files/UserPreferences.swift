//
//  UserPreferences.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let standard = UserDefaults.standard
    
    var favoriteBooks: Set<Book> {
        get {
            if let user = standard.structData(Set<Book>.self, forKey: "favoriteBooks") {
                return user
            }
            return []
        } set {
            standard.setStruct(newValue, forKey: "favoriteBooks")
        }
    }
}

extension UserDefaults {
    
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String) {
        do {
            let data = try JSONEncoder().encode(value)
            set(data, forKey: defaultName)
        } catch {
            DLog("error", error)
        }
        
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        do {
            let data = try JSONDecoder().decode(type, from: encodedData)
            return data
        } catch {
            print("decodingError \(error)")
            return nil
        }
    }
    
}


extension Book:Equatable, Hashable{
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
