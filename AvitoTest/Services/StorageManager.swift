//
//  DataCache.swift
//  AvitoTest
//
//  Created by Антон Заричный on 09.11.2022.
//

import Foundation

enum CacheError: Error {
    case noCacheData
    case decodingCacheError
}

final class StorageManager {
    static let shared = StorageManager()
    
    private let cacheTime = 3600
    private let userDefaults = UserDefaults.standard
    
    private init() {}
// MARK: -  Func saveDataWithDate
    func saveDataWithDate(data: Any, date: Date, dataKey: String, dateKey: String) {
        userDefaults.set(data, forKey: dataKey)
        userDefaults.set(date, forKey: dateKey)
    }
// MARK: - Func userDefaultsExists
    func userDefaultsExists(for key: String) -> Bool {
        guard let _ = userDefaults.object(forKey: key) else { return false }
        
        return true
    }
// MARK: - Func fetchData
    func fetchData<T: Decodable>(dataType: T.Type, with key: String, completion: (Result<T, CacheError>) -> Void) {
        guard let data = userDefaults.data(forKey: key) else {
            completion(.failure(.noCacheData))
            return }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let type = try decoder.decode(T.self, from: data)
            
            completion(.success(type))
            
        } catch {
            completion(.failure(.decodingCacheError))
        }
    }
// MARK: - Func cacheTimer
    func cacheTimer(date: Date, with key: String) -> Bool {
        guard let date = userDefaults.object(forKey: key) as? Date else { return true }
        let currentDate = Calendar.current
        
        guard let timeDifference = currentDate.dateComponents([.second], from: date, to: Date()).second else { return true }
        
        return timeDifference > cacheTime
    }
}
