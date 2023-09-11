// swiftlint:disable all
import Amplify
import Foundation

public struct Partner: Model {
  public let id: String
  public var implementationID: String
  public var name: String?
  public var tag: String?
  public var clientIds: [String?]?
  public var enablePSD2WebForm: Bool?
  public var enablePrePaidExtras: Bool?
  public var enableZeroExcess: Bool?
  public var enableZeroExcessUpSell: Bool?
  public var enableQuickFilters: Bool?
  public var enableRatings: Bool?
  public var loyaltyRegex: String?
  public var enableCovidInsuranceMessage: Bool?
  public var imageBaseURL: String?
  public var landingPageIcons: [String?]?
  public var landingPageIconsDark: [String?]?
  public var enableTracking: Bool?
  public var loyaltyProgramId: String?
  public var ratingType: String?
  public var enableLoyaltyRead: Bool?
  public var forceCalendarFirstDayOfWeek: Int?
  public var enableGooglePay: Bool?
  public var enableApplePay: Bool?
  public var chipDiscountMechanicType: String?
  public var saleBanner: SaleBanner?
  public var supplierBenefitCodes: List<SupplierBenefitCode>?
  public var uspSpec: USPSpec?
  public var settingsMenu: SettingsMenu?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  public var partnerSaleBannerId: String?
  public var partnerUspSpecId: String?
  public var partnerSettingsMenuId: String?
  
  public init(id: String = UUID().uuidString,
      implementationID: String,
      name: String? = nil,
      tag: String? = nil,
      clientIds: [String?]? = nil,
      enablePSD2WebForm: Bool? = nil,
      enablePrePaidExtras: Bool? = nil,
      enableZeroExcess: Bool? = nil,
      enableZeroExcessUpSell: Bool? = nil,
      enableQuickFilters: Bool? = nil,
      enableRatings: Bool? = nil,
      loyaltyRegex: String? = nil,
      enableCovidInsuranceMessage: Bool? = nil,
      imageBaseURL: String? = nil,
      landingPageIcons: [String?]? = nil,
      landingPageIconsDark: [String?]? = nil,
      enableTracking: Bool? = nil,
      loyaltyProgramId: String? = nil,
      ratingType: String? = nil,
      enableLoyaltyRead: Bool? = nil,
      forceCalendarFirstDayOfWeek: Int? = nil,
      enableGooglePay: Bool? = nil,
      enableApplePay: Bool? = nil,
      chipDiscountMechanicType: String? = nil,
      saleBanner: SaleBanner? = nil,
      supplierBenefitCodes: List<SupplierBenefitCode>? = [],
      uspSpec: USPSpec? = nil,
      settingsMenu: SettingsMenu? = nil,
      partnerSaleBannerId: String? = nil,
      partnerUspSpecId: String? = nil,
      partnerSettingsMenuId: String? = nil) {
    self.init(id: id,
      implementationID: implementationID,
      name: name,
      tag: tag,
      clientIds: clientIds,
      enablePSD2WebForm: enablePSD2WebForm,
      enablePrePaidExtras: enablePrePaidExtras,
      enableZeroExcess: enableZeroExcess,
      enableZeroExcessUpSell: enableZeroExcessUpSell,
      enableQuickFilters: enableQuickFilters,
      enableRatings: enableRatings,
      loyaltyRegex: loyaltyRegex,
      enableCovidInsuranceMessage: enableCovidInsuranceMessage,
      imageBaseURL: imageBaseURL,
      landingPageIcons: landingPageIcons,
      landingPageIconsDark: landingPageIconsDark,
      enableTracking: enableTracking,
      loyaltyProgramId: loyaltyProgramId,
      ratingType: ratingType,
      enableLoyaltyRead: enableLoyaltyRead,
      forceCalendarFirstDayOfWeek: forceCalendarFirstDayOfWeek,
      enableGooglePay: enableGooglePay,
      enableApplePay: enableApplePay,
      chipDiscountMechanicType: chipDiscountMechanicType,
      saleBanner: saleBanner,
      supplierBenefitCodes: supplierBenefitCodes,
      uspSpec: uspSpec,
      settingsMenu: settingsMenu,
      createdAt: nil,
      updatedAt: nil,
      partnerSaleBannerId: partnerSaleBannerId,
      partnerUspSpecId: partnerUspSpecId,
      partnerSettingsMenuId: partnerSettingsMenuId)
  }
  internal init(id: String = UUID().uuidString,
      implementationID: String,
      name: String? = nil,
      tag: String? = nil,
      clientIds: [String?]? = nil,
      enablePSD2WebForm: Bool? = nil,
      enablePrePaidExtras: Bool? = nil,
      enableZeroExcess: Bool? = nil,
      enableZeroExcessUpSell: Bool? = nil,
      enableQuickFilters: Bool? = nil,
      enableRatings: Bool? = nil,
      loyaltyRegex: String? = nil,
      enableCovidInsuranceMessage: Bool? = nil,
      imageBaseURL: String? = nil,
      landingPageIcons: [String?]? = nil,
      landingPageIconsDark: [String?]? = nil,
      enableTracking: Bool? = nil,
      loyaltyProgramId: String? = nil,
      ratingType: String? = nil,
      enableLoyaltyRead: Bool? = nil,
      forceCalendarFirstDayOfWeek: Int? = nil,
      enableGooglePay: Bool? = nil,
      enableApplePay: Bool? = nil,
      chipDiscountMechanicType: String? = nil,
      saleBanner: SaleBanner? = nil,
      supplierBenefitCodes: List<SupplierBenefitCode>? = [],
      uspSpec: USPSpec? = nil,
      settingsMenu: SettingsMenu? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil,
      partnerSaleBannerId: String? = nil,
      partnerUspSpecId: String? = nil,
      partnerSettingsMenuId: String? = nil) {
      self.id = id
      self.implementationID = implementationID
      self.name = name
      self.tag = tag
      self.clientIds = clientIds
      self.enablePSD2WebForm = enablePSD2WebForm
      self.enablePrePaidExtras = enablePrePaidExtras
      self.enableZeroExcess = enableZeroExcess
      self.enableZeroExcessUpSell = enableZeroExcessUpSell
      self.enableQuickFilters = enableQuickFilters
      self.enableRatings = enableRatings
      self.loyaltyRegex = loyaltyRegex
      self.enableCovidInsuranceMessage = enableCovidInsuranceMessage
      self.imageBaseURL = imageBaseURL
      self.landingPageIcons = landingPageIcons
      self.landingPageIconsDark = landingPageIconsDark
      self.enableTracking = enableTracking
      self.loyaltyProgramId = loyaltyProgramId
      self.ratingType = ratingType
      self.enableLoyaltyRead = enableLoyaltyRead
      self.forceCalendarFirstDayOfWeek = forceCalendarFirstDayOfWeek
      self.enableGooglePay = enableGooglePay
      self.enableApplePay = enableApplePay
      self.chipDiscountMechanicType = chipDiscountMechanicType
      self.saleBanner = saleBanner
      self.supplierBenefitCodes = supplierBenefitCodes
      self.uspSpec = uspSpec
      self.settingsMenu = settingsMenu
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.partnerSaleBannerId = partnerSaleBannerId
      self.partnerUspSpecId = partnerUspSpecId
      self.partnerSettingsMenuId = partnerSettingsMenuId
  }
}