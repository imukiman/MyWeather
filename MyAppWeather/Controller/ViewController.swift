//
//  ViewController.swift
//  MyAppWeather
//
//  Created by MacOne-YJ4KBJ on 20/06/2022.
//

import UIKit
import RealmSwift
class ViewController: UIViewController {
    
//outlets
    var dataCurrent : CurrentWeather?
    var scrollView = UIScrollView()
    var contentView = UIView()
    var uiView_Top = UIView()
    var uiView_Top_Bar = UIView()
    var language : String = ""
  
    var lbl_location = UILabel()
    var stackView = UIStackView()
    var img_statS = UIImageView()
    var lbl_statS = UILabel()
    var lbl_dateS = UILabel()
    var lbl_tempS = UILabel()
    var view_lbl = UIView()
    var view_stats = UIView()
    var scrollBool = true
    var lineV = UIView()
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var lbl_pressure = UILabel()
    var lbl_pressure1 = UILabel()
    var lbl_humidity = UILabel()
    var lbl_humidity1 = UILabel()
    var lbl_wind = UILabel()
    var lbl_wind1 = UILabel()
    var img_pressure = UIImageView()
    var img_humidity = UIImageView()
    var img_wind = UIImageView()
    
    var gradient = CAGradientLayer()
    var name_location = "none"
    
    var my_latitude : String = ""
    var my_longitude : String = ""

    // 2 số này la vĩ độ và kinh độ địa điểm, sau này có apy lấy vị trí tự động từ google thì thay đổi sau
    var cnt = 8 // day la so ngay ma ban muon hienj thi tu 1 - 16
    var urlApiCurrent : String = ""
    var urlApiDaily : String = ""
    var urlApiHour = ""
    var dataDaily = [ListD]()
    var dataHour = [ListH]()
    var tableView = UITableView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        language = Locale(identifier: Locale.preferredLanguages[0]).languageCode!
        configUiTop()
        configStackView()
        configScrollView()
        configCollectionView()
        configTableView()
        urlApiHour = "https://api.openweathermap.org/data/2.5/forecast?lat=\(my_latitude)&lon=\(my_longitude)&lang=\(language)&cnt=20&appid=\(AppDelegate.myKeyApi1)"
        urlApiDaily = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(my_latitude)&lon=\(my_longitude)&lang=\(language)&cnt=\(cnt)&appid=\(AppDelegate.myKeyApi1)"
        urlApiCurrent = "https://api.openweathermap.org/data/2.5/weather?lat=\(my_latitude)&lon=\(my_longitude)&lang=\(language)&appid=\(AppDelegate.myKeyApi1)"
        loadJson()
    }
    
    func configUiTop(){
        
        view.addSubview(uiView_Top)
        uiView_Top.translatesAutoresizingMaskIntoConstraints = false
        uiView_Top.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        uiView_Top.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        uiView_Top.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        uiView_Top.addSubview(lbl_location)
        lbl_location.translatesAutoresizingMaskIntoConstraints = false
        lbl_location.topAnchor.constraint(equalTo: uiView_Top.topAnchor,constant: 0).isActive = true
        lbl_location.centerXAnchor.constraint(equalTo: uiView_Top.centerXAnchor, constant: 0).isActive = true
        lbl_location.text = name_location
        lbl_location.textColor = .white
        lbl_location.font = .boldSystemFont(ofSize: 30)
    }
    
    func configStackView(){
        uiView_Top.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
      
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: lbl_location.bottomAnchor,constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: uiView_Top.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: uiView_Top.trailingAnchor, constant: 0).isActive = true
        stackView.addArrangedSubview(img_statS)
        
        img_statS.translatesAutoresizingMaskIntoConstraints = false
        img_statS.contentMode = .scaleAspectFit
        img_statS.image = UIImage(named: "01d")
        img_statS.heightAnchor.constraint(equalToConstant:  self.view.bounds.width - 180).isActive = true

        stackView.addArrangedSubview(view_lbl)
        view_lbl.translatesAutoresizingMaskIntoConstraints = false
        view_lbl.heightAnchor.constraint(equalToConstant: view.bounds.width/4).isActive = true
    
        view_lbl.addSubview(lbl_dateS)
        lbl_dateS.translatesAutoresizingMaskIntoConstraints = false
        lbl_dateS.topAnchor.constraint(equalTo: view_lbl.topAnchor, constant: 0).isActive = true
        lbl_dateS.centerXAnchor.constraint(equalTo: view_lbl.centerXAnchor, constant: 0).isActive = true
        lbl_dateS.text = "none"
        lbl_dateS.textAlignment = .center
        lbl_dateS.textColor = .white
        lbl_dateS.font = .boldSystemFont(ofSize: 17)
        
        view_lbl.addSubview(lbl_tempS)
        lbl_tempS.translatesAutoresizingMaskIntoConstraints = false
        lbl_tempS.centerYAnchor.constraint(equalTo: view_lbl.centerYAnchor, constant: 0).isActive = true
        lbl_tempS.centerXAnchor.constraint(equalTo: view_lbl.centerXAnchor, constant: 0).isActive = true
        lbl_tempS.text = "none."
        lbl_tempS.textColor = .white
        lbl_tempS.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        
        view_lbl.addSubview(lbl_statS)
        lbl_statS.translatesAutoresizingMaskIntoConstraints = false
        lbl_statS.centerXAnchor.constraint(equalTo: view_lbl.centerXAnchor, constant: 0).isActive = true
        lbl_statS.bottomAnchor.constraint(equalTo: view_lbl.bottomAnchor, constant: 0).isActive = true
        lbl_statS.text = "none"
        lbl_statS.textColor = .white
        lbl_statS.font = .boldSystemFont(ofSize: 17)
        
        view.addSubview(lineV)
        lineV.translatesAutoresizingMaskIntoConstraints = false
        lineV.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineV.backgroundColor = .white
        lineV.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        lineV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        lineV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        uiView_Top.addSubview(view_stats)
        view_stats.translatesAutoresizingMaskIntoConstraints = false
        view_stats.topAnchor.constraint(equalTo: lineV.bottomAnchor, constant: 10).isActive = true
        view_stats.centerXAnchor.constraint(equalTo: uiView_Top.centerXAnchor, constant: 0).isActive = true
        
        view_stats.addSubview(img_wind)
        img_wind.translatesAutoresizingMaskIntoConstraints = false
        img_wind.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img_wind.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img_wind.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        img_wind.leadingAnchor.constraint(equalTo: view_stats.leadingAnchor, constant: 20).isActive = true
        img_wind.bottomAnchor.constraint(equalTo: view_stats.bottomAnchor, constant: 0).isActive = true
        img_wind.image = UIImage(named: "wind")
        
        view_stats.addSubview(lbl_wind)
        lbl_wind.translatesAutoresizingMaskIntoConstraints = false
        lbl_wind.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        lbl_wind.leadingAnchor.constraint(equalTo: img_wind.trailingAnchor, constant: 5).isActive = true
        lbl_wind.text = "none"
        lbl_wind.textColor = .white
        lbl_wind.font = UIFont.systemFont(ofSize: 14)
        
        view_stats.addSubview(lbl_wind1)
        lbl_wind1.translatesAutoresizingMaskIntoConstraints = false
        lbl_wind1.topAnchor.constraint(equalTo: lbl_wind.bottomAnchor, constant: 0).isActive = true
        lbl_wind1.leadingAnchor.constraint(equalTo: img_wind.trailingAnchor, constant: 5).isActive = true
        lbl_wind1.text = "Gió"
        lbl_wind1.textColor = .white
        lbl_wind1.font = UIFont.systemFont(ofSize: 14)
        
        view_stats.addSubview(img_pressure)
        img_pressure.translatesAutoresizingMaskIntoConstraints = false
        img_pressure.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img_pressure.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img_pressure.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        img_pressure.leadingAnchor.constraint(equalTo: img_wind.trailingAnchor, constant: 80).isActive = true
        img_pressure.image = UIImage(named: "pressure")
        
        view_stats.addSubview(lbl_pressure)
        lbl_pressure.translatesAutoresizingMaskIntoConstraints = false
        lbl_pressure.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        lbl_pressure.leadingAnchor.constraint(equalTo: img_pressure.trailingAnchor, constant: 5).isActive = true
        lbl_pressure.text = "none"
        lbl_pressure.textColor = .white
        lbl_pressure.font = UIFont.systemFont(ofSize: 14)
        
        view_stats.addSubview(lbl_pressure1)
        lbl_pressure1.translatesAutoresizingMaskIntoConstraints = false
        lbl_pressure1.topAnchor.constraint(equalTo: lbl_pressure.bottomAnchor, constant: 0).isActive = true
        lbl_pressure1.leadingAnchor.constraint(equalTo: img_pressure.trailingAnchor, constant: 5).isActive = true
        lbl_pressure1.text = "Áp suất"
        lbl_pressure1.textColor = .white
        lbl_pressure1.font = UIFont.systemFont(ofSize: 14)
        
        view_stats.addSubview(img_humidity)
        img_humidity.translatesAutoresizingMaskIntoConstraints = false
        img_humidity.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img_humidity.heightAnchor.constraint(equalToConstant: 36).isActive = true
        img_humidity.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        img_humidity.leadingAnchor.constraint(equalTo: img_pressure.trailingAnchor, constant: 80).isActive = true
        img_humidity.trailingAnchor.constraint(equalTo: view_stats.trailingAnchor, constant: -80).isActive = true
        img_humidity.image = UIImage(named: "humidity")
        
        view_stats.addSubview(lbl_humidity)
        lbl_humidity.translatesAutoresizingMaskIntoConstraints = false
        lbl_humidity.topAnchor.constraint(equalTo: view_stats.topAnchor, constant: 0).isActive = true
        lbl_humidity.leadingAnchor.constraint(equalTo: img_humidity.trailingAnchor, constant: 5).isActive = true
        lbl_humidity.text = "none"
        lbl_humidity.textColor = .white
        lbl_humidity.font = UIFont.systemFont(ofSize: 14)
        
        view_stats.addSubview(lbl_humidity1)
        lbl_humidity1.translatesAutoresizingMaskIntoConstraints = false
        lbl_humidity1.topAnchor.constraint(equalTo: lbl_humidity.bottomAnchor, constant: 0).isActive = true
        lbl_humidity1.leadingAnchor.constraint(equalTo: img_humidity.trailingAnchor, constant: 5).isActive = true
        lbl_humidity1.text = "Độ ẩm"
        lbl_humidity1.textColor = .white
        lbl_humidity1.font = UIFont.systemFont(ofSize: 14)
    }
    
    
    func configCollectionView(){
        uiView_Top.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view_stats.bottomAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: uiView_Top.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: uiView_Top.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: uiView_Top.bottomAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 60, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "HourCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellCHour")
    }
    
    func configScrollView(){
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.masksToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: uiView_Top.bottomAnchor,constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        scrollView.bounces = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: view.bounds.height - 300).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
    }
    
    func configTableView(){
        contentView.addSubview(tableView)
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DailyDateTableViewCell", bundle: nil), forCellReuseIdentifier: "cellTDay")
        

    }
    func loadJson(){
        let queue = DispatchGroup()
        queue.enter()
        URLSession.shared.dataTask(with: URL(string: urlApiDaily)!) { data, response, errors in
            do{
                let dataD = try JSONDecoder().decode(DailyWeather.self, from: data!)
                for i in 0..<dataD.list.count{
                    self.dataDaily.append(dataD.list[i])
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(errors as Any)
            }
        }.resume()
        queue.leave()
        
        queue.enter()
        URLSession.shared.dataTask(with: URL(string: urlApiHour)!) { data, response, errors in
            do{
                let dataH = try JSONDecoder().decode(HourWeather.self, from: data!)
                    for i in 0..<dataH.list.count{
                        self.dataHour.append(dataH.list[i])
                    }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }catch{
                print(errors as Any)
            }
        }.resume()
        queue.leave()
        
        queue.enter()
        URLSession.shared.dataTask(with: URL(string: urlApiCurrent)!) { data, response, errors in
            do{
                let dataC = try? JSONDecoder().decode(CurrentWeather.self, from: data!)
                self.dataCurrent = dataC
                DispatchQueue.main.async {
                    self.configUI(self.dataCurrent!)
                }
            }
            catch{
                print(errors as Any)
            }
        }.resume()
        queue.leave()
        
        queue.notify(queue: .main) {
            print("Done")
        }
       
    }
    func configUI(_ data: CurrentWeather){
        img_statS.image = UIImage(named: data.weather[0].icon)
        lbl_dateS.text = data.dt.formatDate()
        lbl_wind.text = data.wind.speed.formatWindKh()
        lbl_humidity.text = data.main.humidity.formatHumidity()
        lbl_pressure.text = data.main.pressure.formatMbar()
        lbl_tempS.text = data.main.temp.formatTempC()
        lbl_statS.text = data.weather[0].description.capitalized
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataHour.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCHour", for: indexPath) as! HourCollectionViewCell
        cell.setHour(dataHour[indexPath.row])
        return cell
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 8 && scrollBool {
            scrollBool = !scrollBool
            UIView.animate(withDuration: 1) {
                self.stackView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.stackView.axis = .horizontal
                self.stackView.distribution = .fillEqually
                self.view_lbl.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { _ in
                
            }
        }
        else{
            if scrollView.contentOffset.y < -30 && !scrollBool && scrollView.contentOffset.y <= 5{
                scrollBool = !scrollBool
                UIView.animate(withDuration: 1, delay: 0) {
                    self.stackView.transform = .identity
                    self.stackView.axis = .vertical
                    self.stackView.distribution = .fillProportionally
                    self.view_lbl.transform = .identity
                } completion: { _ in
                    
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDaily.count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTDay") as! DailyDateTableViewCell
        cell.setList(dataDaily[indexPath.row + 1])
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}


