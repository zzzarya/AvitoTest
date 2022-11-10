//
//  Company.swift
//  AvitoTest
//
//  Created by Антон Заричный on 07.11.2022.
//

import Foundation

struct Avito: Decodable {
    let company: Company
}

struct Company: Decodable {
    let name: String
    let employees: [Employee]
}

struct Employee: Decodable {
    let name: String
    let phoneNumber: String
    let skills: [String]
}
