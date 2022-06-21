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
    
    func setHour(_ data : ListH){
        lblHour.text = data.dt.formatTime()
        imgStats.image = UIImage(named: data.weather[0].icon)
        lblTemp.text = data.main.temp.formatTempC()
    }

}
