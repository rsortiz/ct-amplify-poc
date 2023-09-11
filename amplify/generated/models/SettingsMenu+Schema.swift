// swiftlint:disable all
import Amplify
import Foundation

extension SettingsMenu {
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
    let settingsMenu = SettingsMenu.keys
    
    model.listPluralName = "SettingsMenus"
    model.syncPluralName = "SettingsMenus"
    
    model.attributes(
      .primaryKey(fields: [settingsMenu.id])
    )
    
    model.fields(
      .field(settingsMenu.id, is: .required, ofType: .string),
      .field(settingsMenu.type, is: .required, ofType: .string),
      .field(settingsMenu.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(settingsMenu.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SettingsMenu: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}