//
//  SearchViewController.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 19/06/2022.
//

import UIKit
protocol SearchDelegate{
    func changeData()
}

class SearchViewController: UIViewController,UISearchBarDelegate {
    var delegateSearch : SearchDelegate?
    var cities = [Cities]()
    var searchCities = [Cities]()
    var searchBar = UISearchBar()
    var lbl_search = UILabel()
    var topView = UIView()
    var bt_exit = UIButton()
    var tableView = UITableView()
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        cities = loadJson(filename: "City")!
        // Do any additional setup after loading the view.
        configBlur()
        configTop()
        configTableView()
    }
    
    fileprivate func configTop(){
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        topView.addSubview(lbl_search)
        lbl_search.translatesAutoresizingMaskIntoConstraints = false
        lbl_search.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10).isActive = true
        lbl_search.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0).isActive = true
        lbl_search.text = "Nhập tên thành phố bạn muốn tìm"
        lbl_search.textColor = .white
        lbl_search.font = UIFont.systemFont(ofSize: 14)
        
       
        
        topView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .lightGray
        searchBar.searchTextField.textColor = .white
        searchBar.topAnchor.constraint(equalTo: lbl_search.bottomAnchor, constant: 10).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive =  true
        searchBar.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -50).isActive =  true
        searchBar.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10).isActive = true
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchField.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
        
        topView.addSubview(bt_exit)
        bt_exit.translatesAutoresizingMaskIntoConstraints = false
        bt_exit.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor, constant: 0).isActive = true
        bt_exit.setTitle("Hủy", for: .normal)
        bt_exit.setTitleColor(.white, for: .normal)
        bt_exit.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0).isActive = true
        bt_exit.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bt_exit.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bt_exit.addTarget(self, action: #selector(exit_bt), for: .touchUpInside)
        topView.backgroundColor = .darkGray
        
    }
    
    @objc func exit_bt(){
        dismiss(animated: true)
    }
    
    fileprivate func configBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func loadJson(filename fileName: String) -> [Cities]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Cities].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    fileprivate func configTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSearch")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCities = []
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem {
            for i in 0..<self.cities.count{
                if self.cities[i].name.lowercased().contains(searchText.lowercased()){
                    self.searchCities.append(self.cities[i])
                }
            }
            self.tableView.reloadData()
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                      execute: requestWorkItem)
    }

}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch", for: indexPath) as! SearchTableViewCell
        cell.lbl_title.text = searchCities[indexPath.row].name
        cell.lbl_title.textColor = .black
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Location()
        item.name = searchCities[indexPath.row].name
        item.lat = searchCities[indexPath.row].lat.formatStringToDouble()
        item.lng = searchCities[indexPath.row].lng.formatStringToDouble()
        
        let boolCreated = DBManage.shareInstance.checkPrimaryKey(location: item)
        if boolCreated == true{
            let data = DBManage.shareInstance.readData()
            UserDefaults.standard.set(data.count - 1, forKey: "pages")
        }
        delegateSearch?.changeData()
        dismiss(animated: true)
    }
}

