// swiftlint:disable all
import Amplify
import Foundation

extension Partner {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case implementationID
    case name
    case tag
    case clientIds
    case enablePSD2WebForm
    case enablePrePaidExtras
    case enableZeroExcess
    case enableZeroExcessUpSell
    case enableQuickFilters
    case enableRatings
    case loyaltyRegex
    case enableCovidInsuranceMessage
    case imageBaseURL
    case landingPageIcons
    case landingPageIconsDark
    case enableTracking
    case loyaltyProgramId
    case ratingType
    case enableLoyaltyRead
    case forceCalendarFirstDayOfWeek
    case enableGooglePay
    case enableApplePay
    case chipDiscountMechanicType
    case saleBanner
    case supplierBenefitCodes
    case uspSpec
    case settingsMenu
    case createdAt
    case updatedAt
    case partnerSaleBannerId
    case partnerUspSpecId
    case partnerSettingsMenuId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let partner = Partner.keys
    
    model.listPluralName = "Partners"
    model.syncPluralName = "Partners"
    
    model.attributes(
      .primaryKey(fields: [partner.id])
    )
    
    model.fields(
      .field(partner.id, is: .required, ofType: .string),
      .field(partner.implementationID, is: .required, ofType: .string),
      .field(partner.name, is: .optional, ofType: .string),
      .field(partner.tag, is: .optional, ofType: .string),
      .field(partner.clientIds, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(partner.enablePSD2WebForm, is: .optional, ofType: .bool),
      .field(partner.enablePrePaidExtras, is: .optional, ofType: .bool),
      .field(partner.enableZeroExcess, is: .optional, ofType: .bool),
      .field(partner.enableZeroExcessUpSell, is: .optional, ofType: .bool),
      .field(partner.enableQuickFilters, is: .optional, ofType: .bool),
      .field(partner.enableRatings, is: .optional, ofType: .bool),
      .field(partner.loyaltyRegex, is: .optional, ofType: .string),
      .field(partner.enableCovidInsuranceMessage, is: .optional, ofType: .bool),
      .field(partner.imageBaseURL, is: .optional, ofType: .string),
      .field(partner.landingPageIcons, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(partner.landingPageIconsDark, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(partner.enableTracking, is: .optional, ofType: .bool),
      .field(partner.loyaltyProgramId, is: .optional, ofType: .string),
      .field(partner.ratingType, is: .optional, ofType: .string),
      .field(partner.enableLoyaltyRead, is: .optional, ofType: .bool),
      .field(partner.forceCalendarFirstDayOfWeek, is: .optional, ofType: .int),
      .field(partner.enableGooglePay, is: .optional, ofType: .bool),
      .field(partner.enableApplePay, is: .optional, ofType: .bool),
      .field(partner.chipDiscountMechanicType, is: .optional, ofType: .string),
      .hasOne(partner.saleBanner, is: .optional, ofType: SaleBanner.self, associatedWith: SaleBanner.keys.id, targetNames: ["partnerSaleBannerId"]),
      .hasMany(partner.supplierBenefitCodes, is: .optional, ofType: SupplierBenefitCode.self, associatedWith: SupplierBenefitCode.keys.partnerSupplierBenefitCodesId),
      .hasOne(partner.uspSpec, is: .optional, ofType: USPSpec.self, associatedWith: USPSpec.keys.id, targetNames: ["partnerUspSpecId"]),
      .hasOne(partner.settingsMenu, is: .optional, ofType: SettingsMenu.self, associatedWith: SettingsMenu.keys.id, targetNames: ["partnerSettingsMenuId"]),
      .field(partner.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(partner.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(partner.partnerSaleBannerId, is: .optional, ofType: .string),
      .field(partner.partnerUspSpecId, is: .optional, ofType: .string),
      .field(partner.partnerSettingsMenuId, is: .optional, ofType: .string)
    )
    }
}

extension Partner: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}