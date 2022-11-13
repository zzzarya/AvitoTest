//
//  NetworkManager.swift
//  AvitoTest
//
//  Created by Антон Заричный on 08.11.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case responseError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    let avitoUrl = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    
    private init() {}
// MARK: - Fetch JSON
    func fetch<T: Decodable>(dataType: T.Type, from url: String?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode != 200 {
                completion(.failure(.responseError))
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let type = try decoder.decode(T.self, from: data)
                
                completion(.success(type))
                StorageManager.shared.saveDataWithDate(
                                                        data: data,
                                                        date: Date(),
                                                        dataKey: "data",
                                                        dateKey: "date"
                )
                
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
    

