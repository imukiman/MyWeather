//
//  AllLocationsViewController.swift
//  MyAppWeather
//
//  Created by MacOne-YJ4KBJ on 22/06/2022.
//

import UIKit
import RealmSwift
protocol AllLocationDelegate{
    func clickDelegate(pages: Int)
}
class AllLocationsViewController: UIViewController {
    var allLocation = [Cities]()
    var tableView = UITableView()
    var add_bt = UIButton()
    var viewContent = UIView()
    var gradient = CAGradientLayer()
    let vc = SearchViewController()
    var delegate : AllLocationDelegate?
    var edit_bt = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        configUi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       datainTableView()
    }
    func datainTableView(){
        allLocation = []
        let data = DBManage.shareInstance.readData()
        for i in 0..<data.count{
            let data = Cities(name: data[i].name, lat: data[i].lat, lng: data[i].lng)
            allLocation.append(data)
        }
        tableView.reloadData()
    }
    fileprivate func configUi(){
        view.addSubview(viewContent)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewContent.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        viewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        viewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        viewContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        gradient.colors = [UIColor.blue1.cgColor,UIColor.blue2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        viewContent.layer.insertSublayer(gradient, at: 0)
        view.sendSubviewToBack(viewContent)
        
        viewContent.addSubview(add_bt)
        add_bt.translatesAutoresizingMaskIntoConstraints = false
        add_bt.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor,constant: -16).isActive = true
        add_bt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        add_bt.widthAnchor.constraint(equalToConstant: 30).isActive = true
        add_bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        add_bt.setBackgroundImage(UIImage(named: "add"), for: .normal)
        add_bt.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        
        viewContent.addSubview(edit_bt)
        edit_bt.translatesAutoresizingMaskIntoConstraints = false
        edit_bt.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor,constant: 16).isActive = true
        edit_bt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        edit_bt.widthAnchor.constraint(equalToConstant: 50).isActive = true
        edit_bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        edit_bt.setTitle("Edit", for: .normal)
        edit_bt.addTarget(self, action: #selector(edit_Button), for: .touchUpInside)
        
        viewContent.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: edit_bt.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "AllLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "cellLocation")
        
    }
    @objc func addLocation(){
        vc.delegateSearch = self
        present(vc, animated: true)
    }
    
    @objc func edit_Button(_ sender: UIButton){
        if !sender.isSelected {
            sender.isSelected = !sender.isSelected
            edit_bt.setTitle("Done", for: .normal)
            tableView.isEditing = true
        }
        else{
            sender.isSelected = !sender.isSelected
            edit_bt.setTitle("Edit", for: .normal)
            tableView.isEditing = false
        }
    }
}

extension AllLocationsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLocation") as! AllLocationTableViewCell
        cell.lblLocation.text = allLocation[indexPath.row].name
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "pages")
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                DBManage.shareInstance.deleteAnyObject(code: self.allLocation[indexPath.row].name)
                self.allLocation.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Đổi vị trí của 2 phần tử contact trong mảng dataSource contacts
        allLocation.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        DBManage.shareInstance.deleteAllObject()
        swapItem()
    }
    
    func swapItem(){
        for i in 0..<allLocation.count{
            let data = Location()
            data.name = allLocation[i].name
            data.lat = allLocation[i].lat
            data.lng = allLocation[i].lng
            DBManage.shareInstance.addData(data)
        }
    }
}

extension AllLocationsViewController : SearchDelegate{
    func changeData() {
        self.datainTableView()
    }
}
