//
//  Purchase+CoreDataClass.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 07/03/23.
//
//

import Foundation
import CoreData

@objc(Purchase)
public class Purchase: NSManagedObject, Codable {
  required convenience public init(from decoder: Decoder) throws {
    guard let viewContext = decoder.userInfo[.context] as? NSManagedObjectContext else {
      throw ContextError.NoContextFound
    }
    self.init(context: viewContext)
    
    /// Decoding Items
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(UUID.self, forKey: .id)
    dateOfPurchase = try values.decode(Date.self, forKey: .dateOfPurchase)
    title = try values.decode(String.self, forKey: .title)
    amountSpent = try values.decode(Double.self, forKey: .amountSpent)
  }
  
  /// Conforming Encoding
  public func encode(to encoder: Encoder) throws {
    var values = encoder.container(keyedBy: CodingKeys.self)
    try values.encode(id, forKey: .id)
    try values.encode(title, forKey: .title)
    try values.encode(amountSpent, forKey: .amountSpent)
    try values.encode(dateOfPurchase, forKey: .dateOfPurchase)
  }
  
  enum CodingKeys: CodingKey {
    case id, title, dateOfPurchase, amountSpent
  }
}

extension CodingUserInfoKey {
  static let context = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum ContextError: Error {
  case NoContextFound
}
