//
//  HourCollectionViewCell.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 15/06/2022.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgStats: UIImageView!
    @IBOutlet weak var lblHour: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTemp.font = UIFont.systemFont(ofSize: 16)
        lblTemp.textColor = .white
        lblHour.textColor = .white
        lblHour.font = .boldSystemFont(ofSize: 17)
    }
    
    func setHour(_ data : Hourly, _ timeZone: String, _ indexPath : Int){
        if indexPath == 0{
            lblHour.text = "Bây giờ"
        }
        else{
            lblHour.text = data.dt.formatTime(timeZone)
        }
        imgStats.image = UIImage(named: data.weather[0].icon)
        lblTemp.text = data.temp.formatTempC()
    }

}
