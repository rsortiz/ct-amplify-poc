// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "6dbd2896e4bdd21d6491347e3959fc57"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Booking.self)
  }
}