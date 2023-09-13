// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3b9693961d22967b74d77f8e7c28cc7b"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Booking.self)
    ModelRegistry.register(modelType: Partner.self)
    ModelRegistry.register(modelType: SaleBanner.self)
    ModelRegistry.register(modelType: SupplierBenefitCode.self)
    ModelRegistry.register(modelType: USPSpec.self)
    ModelRegistry.register(modelType: SettingsMenu.self)
  }
}