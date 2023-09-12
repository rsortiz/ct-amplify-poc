// swiftlint:disable all
import Amplify
import Foundation

extension USPSpec {
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
    let uSPSpec = USPSpec.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "USPSpecs"
    model.syncPluralName = "USPSpecs"
    
    model.attributes(
      .primaryKey(fields: [uSPSpec.id])
    )
    
    model.fields(
      .field(uSPSpec.id, is: .required, ofType: .string),
      .field(uSPSpec.type, is: .required, ofType: .string),
      .field(uSPSpec.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(uSPSpec.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension USPSpec: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}