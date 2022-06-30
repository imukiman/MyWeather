//
//  SearchViewController.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 19/06/2022.
//

import UIKit
import RealmSwift
protocol SearchDelegate{
    func changeData()
}

class SearchViewController: UIViewController,UISearchBarDelegate {
    var delegateSearch : SearchDelegate?
    var nameCity = ""
    var searchCities = [Cities]()
    var searchBar = UISearchBar()
    var lbl_search = UILabel()
    var topView = UIView()
    var bt_exit = UIButton()
    var tableView = UITableView()
    var urlSearch : String = ""
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        //cities = loadJson(filename: "Cities")!
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
        resetSearch()
        dismiss(animated: true)
    }
    
    func resetSearch(){
        searchCities = []
        searchBar.text = ""
        tableView.reloadData()
    }
    
    fileprivate func configBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "cellSearch")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCities = []
        nameCity = searchText
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [self] in
            let convertsearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            urlSearch = "https://nominatim.openstreetmap.org/search.php?q=\(convertsearchText!)&format=json"
            guard let dataURl = URL(string: urlSearch) else{
                return
            }
            URLSession.shared.dataTask(with: dataURl) { data, response, error in
                if error == nil{
                    do{
                        let data1 = try JSONDecoder().decode([Cities].self, from: data!)
                        self.searchCities = data1
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }catch{
                        
                    }
                }
                else{
                    print(error!)
                }
            }.resume()
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
        cell.lbl_title.text = searchCities[indexPath.row].displayName
        cell.lbl_title.textColor = .black
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = Location()
        item.name = searchCities[indexPath.row].displayName.cutComma()
        item.lat = searchCities[indexPath.row].lat
        item.lon = searchCities[indexPath.row].lon
        
        DBManage.shareInstance.checkPrimaryKey(location: item)
        delegateSearch?.changeData()
        resetSearch()
        dismiss(animated: true)
    }
}

