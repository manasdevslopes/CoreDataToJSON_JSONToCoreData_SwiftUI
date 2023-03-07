//
//  Purchase+Extensions.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 07/03/23.
//

import UIKit

extension Purchase {
  var titleView: String {
    title ?? ""
  }
  
  var dateView: Date {
    dateOfPurchase ?? .init()
  }
  
  var amountView: Double {
    amountSpent
  }
}
