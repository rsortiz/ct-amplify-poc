// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "efb580a33ba2e41aff9061f75d718e8f"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Booking.self)
    ModelRegistry.register(modelType: Partner.self)
    ModelRegistry.register(modelType: SaleBanner.self)
    ModelRegistry.register(modelType: SupplierBenefitCode.self)
    ModelRegistry.register(modelType: USPSpec.self)
    ModelRegistry.register(modelType: SettingsMenu.self)
  }
}