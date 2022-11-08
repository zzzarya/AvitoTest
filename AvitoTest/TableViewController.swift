//
//  TableViewController.swift
//  AvitoTest
//
//  Created by Антон Заричный on 07.11.2022.
//

import UIKit

final class TableViewController: UITableViewController {
    
    private var employees: [Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
    }
// MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        employees.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        employees[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath)
        
        let employee = employees[indexPath.section]
        
        cell.imageView?.image = indexPath.row == 0
        ? UIImage(systemName: "phone")
        : UIImage(systemName: "wrench.and.screwdriver.fill")
        
        cell.textLabel?.text = indexPath.row == 0
        ? employee.phoneNumber
        : employee.skills.joined(separator: ", ")
        
        return cell
    }
// MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Networking
extension TableViewController {
    private func fetchJSON() {
        NetworkManager.shared.fetch(dataType: Avito.self, from: avitoUrl) { [weak self] result in
            switch result {
            case .success(let avito):
                self?.employees = avito.company.employees.sorted { $0.name < $1.name }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
