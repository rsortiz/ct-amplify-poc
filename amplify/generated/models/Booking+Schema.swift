// swiftlint:disable all
import Amplify
import Foundation

extension Booking {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case resID
    case username
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let booking = Booking.keys
    
    model.listPluralName = "Bookings"
    model.syncPluralName = "Bookings"
    
    model.attributes(
      .primaryKey(fields: [booking.id])
    )
    
    model.fields(
      .field(booking.id, is: .required, ofType: .string),
      .field(booking.resID, is: .required, ofType: .string),
      .field(booking.username, is: .required, ofType: .string),
      .field(booking.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(booking.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Booking: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}