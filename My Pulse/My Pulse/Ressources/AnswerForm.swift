//
//  AnswerForm.swift
//  My Pulse
//
//  Created by Farah Nedjadi on 10/05/2018.
//  Copyright © 2018 MTI. All rights reserved.
//

import Foundation
import UIKit

enum AnswerType {
    case date,
    number,
    decimal,
    select,
    country,
    range,
    boolean
}

extension AnswerType {
    var ui : String {
        switch self {
        case .date:
            return "UIDatePicker"
        case .number, .decimal :
            return "UITextField"
        case .select:
            return "UITableView"
        case .country, .range, .boolean:
            return "UIPickerView" //NSLocale.ISOCountryCodes()
        }
    }
    
}
