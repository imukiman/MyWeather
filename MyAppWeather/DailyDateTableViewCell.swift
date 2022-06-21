//
//  DailyDateTableViewCell.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 15/06/2022.
//

import UIKit

class DailyDateTableViewCell: UITableViewCell {
    @IBOutlet weak var imgStatD: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTemP: UILabel!
    @IBOutlet weak var heightNS: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        heightNS.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setList(_ data : ListD){
        lblTemP.font = UIFont.systemFont(ofSize: 16)
        lblTemP.textColor = .white
        lblDate.textColor = .white
        lblDate.font = .boldSystemFont(ofSize: 17)
        
        let min = data.temp.min.formatTempC()
        let max = data.temp.max.formatTempC()
        lblTemP.text = "\(min)/\(max)"
        lblDate.text = data.dt.formatDay()
        imgStatD.image = UIImage(named: "\(data.weather[0].icon)")
    }
    
}
