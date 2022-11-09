//
//  DataCache.swift
//  AvitoTest
//
//  Created by Антон Заричный on 09.11.2022.
//

import Foundation

enum CacheError: Error {
    case noData
    case decodingError
}

final class StorageManager {
    static let shared = StorageManager()
    
    let cacheTime = 3600
    
    let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func saveDataWithDate(data: Any, date: Date, dataKey: String, dateKey: String) {
        userDefaults.set(data, forKey: dataKey)
        userDefaults.set(date, forKey: dateKey)
    }
    
    func fetchData<T: Decodable>(dataType: T.Type, with key: String, completion: (Result<T, CacheError>) -> Void) {
        guard let data = userDefaults.data(forKey: key) else {
            completion(.failure(.noData))
            return }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let type = try decoder.decode(T.self, from: data)
            
            completion(.success(type))
            
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
    func cacheTimer(date: Date, with key: String) -> Bool {
        guard let date = userDefaults.object(forKey: key) as? Date else { return true }
        let currentDate = Calendar.current
        
        guard let timeDifference = currentDate.dateComponents([.second], from: date, to: Date()).second else { return true }
        
        print(timeDifference)
        
        return timeDifference > cacheTime
    }
}
