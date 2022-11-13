//
//  TableViewController.swift
//  AvitoTest
//
//  Created by Антон Заричный on 07.11.2022.
//

import UIKit

final class EmployeesTableViewController: UITableViewController {
    
    private var employees: [Employee] = []
    
    private var employeesRefreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = employeesRefreshControl
        netMonitoring()
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
// MARK: - Func for UIRefreshControl
   @objc private func refresh(sender: UIRefreshControl) {
       netMonitoring()
       sender.endRefreshing()
    }
}
// MARK: - ParsingJSON
extension EmployeesTableViewController {
    private func fetchJSON(completion: @escaping(Result<[Employee], Error>) -> Void) {
        if StorageManager.shared.cacheTimer(date: Date(), with: "date") {
            NetworkManager.shared.fetch(dataType: Avito.self, from: NetworkManager.shared.avitoUrl) { result in
                switch result {
                case .success(let avito):
                    completion(.success(avito.company.employees))
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            StorageManager.shared.fetchData(dataType: Avito.self, with: "data") { result in
                switch result {
                case .success(let avito):
                    completion(.success(avito.company.employees))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
// MARK: - AlertController
extension EmployeesTableViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "No internet connection",
                                      message: "Please check your internet connection",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
// MARK: - InternetMonitorng
extension EmployeesTableViewController {
    private func netMonitoring() {
        NetworkMonitor.shared.startMonitoring(completion: { [weak self] isConnected in
            if isConnected || StorageManager.shared.userDefaultsExists(for: "data") {
                DispatchQueue.main.async {
                    self?.fetchJSON(completion: { result in
                        switch result {
                        case .success(let employees):
                            self?.employees = employees.sorted { $0.name < $1.name }
                            
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self?.showAlert()
                }
            }
        })
    }
}
