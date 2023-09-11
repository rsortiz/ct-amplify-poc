// swiftlint:disable all
import Amplify
import Foundation

public struct SaleBanner: Model {
  public let id: String
  public var type: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      type: String) {
    self.init(id: id,
      type: type,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      type: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.type = type
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}