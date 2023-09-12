// swiftlint:disable all
import Amplify
import Foundation

extension SaleBanner {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case type
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let saleBanner = SaleBanner.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SaleBanners"
    model.syncPluralName = "SaleBanners"
    
    model.attributes(
      .primaryKey(fields: [saleBanner.id])
    )
    
    model.fields(
      .field(saleBanner.id, is: .required, ofType: .string),
      .field(saleBanner.type, is: .required, ofType: .string),
      .field(saleBanner.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(saleBanner.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SaleBanner: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}