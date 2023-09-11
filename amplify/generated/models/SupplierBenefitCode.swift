// swiftlint:disable all
import Amplify
import Foundation

public struct SupplierBenefitCode: Model {
  public let id: String
  public var type: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  public var partnerSupplierBenefitCodesId: String?
  
  public init(id: String = UUID().uuidString,
      type: String,
      partnerSupplierBenefitCodesId: String? = nil) {
    self.init(id: id,
      type: type,
      createdAt: nil,
      updatedAt: nil,
      partnerSupplierBenefitCodesId: partnerSupplierBenefitCodesId)
  }
  internal init(id: String = UUID().uuidString,
      type: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil,
      partnerSupplierBenefitCodesId: String? = nil) {
      self.id = id
      self.type = type
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.partnerSupplierBenefitCodesId = partnerSupplierBenefitCodesId
  }
}