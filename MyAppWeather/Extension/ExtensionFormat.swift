//
//  ExtensionFormat.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 15/06/2022.
//

import Foundation
import UIKit

extension String{
    func formatStringToDouble() -> Double{
        let double = Double(self)!
        return double
    }
}

extension Double{
    func formatDouble() -> Double{
        let a = String(format: "%.4f", self)
        return Double(a)!
    }
    func formatWindMs() -> String{
        return String(format: "%.2f", self) + " M/s"
    }
    
    func formatWindMilh() -> String{
        let mil = self * 3600 / 1000 / 1.6
        return String(format: "%.1f", mil) + " Mil/h"
    }
    
    func formatWindKh() -> String{
        let km = self * 3600 / 1000
        return String(format: "%.0f", km) + " Km/h"
    }
    
    func formatTempC() -> String{
        let tempC = self - 273.15
        return String(format: "%.0f", tempC) + "°C"
    }
    
    func formatHumidity() -> String{
        return String(format: "%.0f", self) + "%"
    }
    
    func formatDate() -> String{
        let timeResult : Double = self
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.dateFormat = "EEEE | dd.MM"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
   
    }
    
    func formatDay() -> String{
        let timeResult : Double = self
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = .current
        let localDay = dateFormatter.string(from: date)
        return localDay
    }
    
    func formatTime() -> String{
        let timeResult : Double = self
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func formatMbar() -> String{
        return String(format: "%.0f", self) + " Mbar"
    }
    
    func formatAtm() -> String{
        let atm = self * 0.99 / 1000
        return String(format: "%.2f", atm) + " Atm"
    }
    
    func formatmmHg() -> String{
        let mmHg = self * 750 / 1000
        return String(format: "%.0f", mmHg) + " mmHg"
    }
    func formatTempF() -> String{
        let f = (self - 273.15) * 9/5 + 32
        return String(format: "%.0f", f) + "°F"
    }
}
