// swiftlint:disable all
import Amplify
import Foundation

public struct Booking: Model {
  public let id: String
  public var resID: String
  public var username: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      resID: String,
      username: String) {
    self.init(id: id,
      resID: resID,
      username: username,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      resID: String,
      username: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.resID = resID
      self.username = username
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}