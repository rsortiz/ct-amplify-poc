// swiftlint:disable all
import Amplify
import Foundation

extension SupplierBenefitCode {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case type
    case createdAt
    case updatedAt
    case partnerSupplierBenefitCodesId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let supplierBenefitCode = SupplierBenefitCode.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SupplierBenefitCodes"
    model.syncPluralName = "SupplierBenefitCodes"
    
    model.attributes(
      .primaryKey(fields: [supplierBenefitCode.id])
    )
    
    model.fields(
      .field(supplierBenefitCode.id, is: .required, ofType: .string),
      .field(supplierBenefitCode.type, is: .required, ofType: .string),
      .field(supplierBenefitCode.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(supplierBenefitCode.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(supplierBenefitCode.partnerSupplierBenefitCodesId, is: .optional, ofType: .string)
    )
    }
}

extension SupplierBenefitCode: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}