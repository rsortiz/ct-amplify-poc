//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreateBookingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, resId: String, username: String, version: Int? = nil) {
    graphQLMap = ["id": id, "resID": resId, "username": username, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var resId: String {
    get {
      return graphQLMap["resID"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "resID")
    }
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ModelBookingConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(resId: ModelStringInput? = nil, username: ModelStringInput? = nil, and: [ModelBookingConditionInput?]? = nil, or: [ModelBookingConditionInput?]? = nil, not: ModelBookingConditionInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["resID": resId, "username": username, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var resId: ModelStringInput? {
    get {
      return graphQLMap["resID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "resID")
    }
  }

  public var username: ModelStringInput? {
    get {
      return graphQLMap["username"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var and: [ModelBookingConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelBookingConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelBookingConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelBookingConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelBookingConditionInput? {
    get {
      return graphQLMap["not"] as! ModelBookingConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct ModelBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct UpdateBookingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, resId: String? = nil, username: String? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "resID": resId, "username": username, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var resId: String? {
    get {
      return graphQLMap["resID"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "resID")
    }
  }

  public var username: String? {
    get {
      return graphQLMap["username"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DeleteBookingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct CreatePartnerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, version: Int? = nil, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "_version": version, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var implementationId: String {
    get {
      return graphQLMap["implementationID"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "implementationID")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var tag: String? {
    get {
      return graphQLMap["tag"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tag")
    }
  }

  public var clientIds: [String?]? {
    get {
      return graphQLMap["clientIds"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientIds")
    }
  }

  public var enablePsd2WebForm: Bool? {
    get {
      return graphQLMap["enablePSD2WebForm"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePSD2WebForm")
    }
  }

  public var enablePrePaidExtras: Bool? {
    get {
      return graphQLMap["enablePrePaidExtras"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePrePaidExtras")
    }
  }

  public var enableZeroExcess: Bool? {
    get {
      return graphQLMap["enableZeroExcess"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcess")
    }
  }

  public var enableZeroExcessUpSell: Bool? {
    get {
      return graphQLMap["enableZeroExcessUpSell"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcessUpSell")
    }
  }

  public var enableQuickFilters: Bool? {
    get {
      return graphQLMap["enableQuickFilters"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableQuickFilters")
    }
  }

  public var enableRatings: Bool? {
    get {
      return graphQLMap["enableRatings"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableRatings")
    }
  }

  public var loyaltyRegex: String? {
    get {
      return graphQLMap["loyaltyRegex"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyRegex")
    }
  }

  public var enableCovidInsuranceMessage: Bool? {
    get {
      return graphQLMap["enableCovidInsuranceMessage"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
    }
  }

  public var imageBaseUrl: String? {
    get {
      return graphQLMap["imageBaseURL"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageBaseURL")
    }
  }

  public var landingPageIcons: [String?]? {
    get {
      return graphQLMap["landingPageIcons"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIcons")
    }
  }

  public var landingPageIconsDark: [String?]? {
    get {
      return graphQLMap["landingPageIconsDark"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIconsDark")
    }
  }

  public var enableTracking: Bool? {
    get {
      return graphQLMap["enableTracking"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableTracking")
    }
  }

  public var loyaltyProgramId: String? {
    get {
      return graphQLMap["loyaltyProgramId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyProgramId")
    }
  }

  public var ratingType: String? {
    get {
      return graphQLMap["ratingType"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ratingType")
    }
  }

  public var enableLoyaltyRead: Bool? {
    get {
      return graphQLMap["enableLoyaltyRead"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableLoyaltyRead")
    }
  }

  public var forceCalendarFirstDayOfWeek: Int? {
    get {
      return graphQLMap["forceCalendarFirstDayOfWeek"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
    }
  }

  public var enableGooglePay: Bool? {
    get {
      return graphQLMap["enableGooglePay"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableGooglePay")
    }
  }

  public var enableApplePay: Bool? {
    get {
      return graphQLMap["enableApplePay"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableApplePay")
    }
  }

  public var chipDiscountMechanicType: String? {
    get {
      return graphQLMap["chipDiscountMechanicType"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "chipDiscountMechanicType")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var partnerSaleBannerId: GraphQLID? {
    get {
      return graphQLMap["partnerSaleBannerId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSaleBannerId")
    }
  }

  public var partnerUspSpecId: GraphQLID? {
    get {
      return graphQLMap["partnerUspSpecId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerUspSpecId")
    }
  }

  public var partnerSettingsMenuId: GraphQLID? {
    get {
      return graphQLMap["partnerSettingsMenuId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSettingsMenuId")
    }
  }
}

public struct ModelPartnerConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(implementationId: ModelStringInput? = nil, name: ModelStringInput? = nil, tag: ModelStringInput? = nil, clientIds: ModelStringInput? = nil, enablePsd2WebForm: ModelBooleanInput? = nil, enablePrePaidExtras: ModelBooleanInput? = nil, enableZeroExcess: ModelBooleanInput? = nil, enableZeroExcessUpSell: ModelBooleanInput? = nil, enableQuickFilters: ModelBooleanInput? = nil, enableRatings: ModelBooleanInput? = nil, loyaltyRegex: ModelStringInput? = nil, enableCovidInsuranceMessage: ModelBooleanInput? = nil, imageBaseUrl: ModelStringInput? = nil, landingPageIcons: ModelStringInput? = nil, landingPageIconsDark: ModelStringInput? = nil, enableTracking: ModelBooleanInput? = nil, loyaltyProgramId: ModelStringInput? = nil, ratingType: ModelStringInput? = nil, enableLoyaltyRead: ModelBooleanInput? = nil, forceCalendarFirstDayOfWeek: ModelIntInput? = nil, enableGooglePay: ModelBooleanInput? = nil, enableApplePay: ModelBooleanInput? = nil, chipDiscountMechanicType: ModelStringInput? = nil, and: [ModelPartnerConditionInput?]? = nil, or: [ModelPartnerConditionInput?]? = nil, not: ModelPartnerConditionInput? = nil, deleted: ModelBooleanInput? = nil, partnerSaleBannerId: ModelIDInput? = nil, partnerUspSpecId: ModelIDInput? = nil, partnerSettingsMenuId: ModelIDInput? = nil) {
    graphQLMap = ["implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "and": and, "or": or, "not": not, "_deleted": deleted, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId]
  }

  public var implementationId: ModelStringInput? {
    get {
      return graphQLMap["implementationID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "implementationID")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var tag: ModelStringInput? {
    get {
      return graphQLMap["tag"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tag")
    }
  }

  public var clientIds: ModelStringInput? {
    get {
      return graphQLMap["clientIds"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientIds")
    }
  }

  public var enablePsd2WebForm: ModelBooleanInput? {
    get {
      return graphQLMap["enablePSD2WebForm"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePSD2WebForm")
    }
  }

  public var enablePrePaidExtras: ModelBooleanInput? {
    get {
      return graphQLMap["enablePrePaidExtras"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePrePaidExtras")
    }
  }

  public var enableZeroExcess: ModelBooleanInput? {
    get {
      return graphQLMap["enableZeroExcess"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcess")
    }
  }

  public var enableZeroExcessUpSell: ModelBooleanInput? {
    get {
      return graphQLMap["enableZeroExcessUpSell"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcessUpSell")
    }
  }

  public var enableQuickFilters: ModelBooleanInput? {
    get {
      return graphQLMap["enableQuickFilters"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableQuickFilters")
    }
  }

  public var enableRatings: ModelBooleanInput? {
    get {
      return graphQLMap["enableRatings"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableRatings")
    }
  }

  public var loyaltyRegex: ModelStringInput? {
    get {
      return graphQLMap["loyaltyRegex"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyRegex")
    }
  }

  public var enableCovidInsuranceMessage: ModelBooleanInput? {
    get {
      return graphQLMap["enableCovidInsuranceMessage"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
    }
  }

  public var imageBaseUrl: ModelStringInput? {
    get {
      return graphQLMap["imageBaseURL"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageBaseURL")
    }
  }

  public var landingPageIcons: ModelStringInput? {
    get {
      return graphQLMap["landingPageIcons"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIcons")
    }
  }

  public var landingPageIconsDark: ModelStringInput? {
    get {
      return graphQLMap["landingPageIconsDark"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIconsDark")
    }
  }

  public var enableTracking: ModelBooleanInput? {
    get {
      return graphQLMap["enableTracking"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableTracking")
    }
  }

  public var loyaltyProgramId: ModelStringInput? {
    get {
      return graphQLMap["loyaltyProgramId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyProgramId")
    }
  }

  public var ratingType: ModelStringInput? {
    get {
      return graphQLMap["ratingType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ratingType")
    }
  }

  public var enableLoyaltyRead: ModelBooleanInput? {
    get {
      return graphQLMap["enableLoyaltyRead"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableLoyaltyRead")
    }
  }

  public var forceCalendarFirstDayOfWeek: ModelIntInput? {
    get {
      return graphQLMap["forceCalendarFirstDayOfWeek"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
    }
  }

  public var enableGooglePay: ModelBooleanInput? {
    get {
      return graphQLMap["enableGooglePay"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableGooglePay")
    }
  }

  public var enableApplePay: ModelBooleanInput? {
    get {
      return graphQLMap["enableApplePay"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableApplePay")
    }
  }

  public var chipDiscountMechanicType: ModelStringInput? {
    get {
      return graphQLMap["chipDiscountMechanicType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "chipDiscountMechanicType")
    }
  }

  public var and: [ModelPartnerConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPartnerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPartnerConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPartnerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPartnerConditionInput? {
    get {
      return graphQLMap["not"] as! ModelPartnerConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var partnerSaleBannerId: ModelIDInput? {
    get {
      return graphQLMap["partnerSaleBannerId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSaleBannerId")
    }
  }

  public var partnerUspSpecId: ModelIDInput? {
    get {
      return graphQLMap["partnerUspSpecId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerUspSpecId")
    }
  }

  public var partnerSettingsMenuId: ModelIDInput? {
    get {
      return graphQLMap["partnerSettingsMenuId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSettingsMenuId")
    }
  }
}

public struct ModelIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdatePartnerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, implementationId: String? = nil, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, version: Int? = nil, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "_version": version, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var implementationId: String? {
    get {
      return graphQLMap["implementationID"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "implementationID")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var tag: String? {
    get {
      return graphQLMap["tag"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tag")
    }
  }

  public var clientIds: [String?]? {
    get {
      return graphQLMap["clientIds"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientIds")
    }
  }

  public var enablePsd2WebForm: Bool? {
    get {
      return graphQLMap["enablePSD2WebForm"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePSD2WebForm")
    }
  }

  public var enablePrePaidExtras: Bool? {
    get {
      return graphQLMap["enablePrePaidExtras"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePrePaidExtras")
    }
  }

  public var enableZeroExcess: Bool? {
    get {
      return graphQLMap["enableZeroExcess"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcess")
    }
  }

  public var enableZeroExcessUpSell: Bool? {
    get {
      return graphQLMap["enableZeroExcessUpSell"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcessUpSell")
    }
  }

  public var enableQuickFilters: Bool? {
    get {
      return graphQLMap["enableQuickFilters"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableQuickFilters")
    }
  }

  public var enableRatings: Bool? {
    get {
      return graphQLMap["enableRatings"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableRatings")
    }
  }

  public var loyaltyRegex: String? {
    get {
      return graphQLMap["loyaltyRegex"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyRegex")
    }
  }

  public var enableCovidInsuranceMessage: Bool? {
    get {
      return graphQLMap["enableCovidInsuranceMessage"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
    }
  }

  public var imageBaseUrl: String? {
    get {
      return graphQLMap["imageBaseURL"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageBaseURL")
    }
  }

  public var landingPageIcons: [String?]? {
    get {
      return graphQLMap["landingPageIcons"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIcons")
    }
  }

  public var landingPageIconsDark: [String?]? {
    get {
      return graphQLMap["landingPageIconsDark"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIconsDark")
    }
  }

  public var enableTracking: Bool? {
    get {
      return graphQLMap["enableTracking"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableTracking")
    }
  }

  public var loyaltyProgramId: String? {
    get {
      return graphQLMap["loyaltyProgramId"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyProgramId")
    }
  }

  public var ratingType: String? {
    get {
      return graphQLMap["ratingType"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ratingType")
    }
  }

  public var enableLoyaltyRead: Bool? {
    get {
      return graphQLMap["enableLoyaltyRead"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableLoyaltyRead")
    }
  }

  public var forceCalendarFirstDayOfWeek: Int? {
    get {
      return graphQLMap["forceCalendarFirstDayOfWeek"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
    }
  }

  public var enableGooglePay: Bool? {
    get {
      return graphQLMap["enableGooglePay"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableGooglePay")
    }
  }

  public var enableApplePay: Bool? {
    get {
      return graphQLMap["enableApplePay"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableApplePay")
    }
  }

  public var chipDiscountMechanicType: String? {
    get {
      return graphQLMap["chipDiscountMechanicType"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "chipDiscountMechanicType")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var partnerSaleBannerId: GraphQLID? {
    get {
      return graphQLMap["partnerSaleBannerId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSaleBannerId")
    }
  }

  public var partnerUspSpecId: GraphQLID? {
    get {
      return graphQLMap["partnerUspSpecId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerUspSpecId")
    }
  }

  public var partnerSettingsMenuId: GraphQLID? {
    get {
      return graphQLMap["partnerSettingsMenuId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSettingsMenuId")
    }
  }
}

public struct DeletePartnerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct CreateSaleBannerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: String, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ModelSaleBannerConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(type: ModelStringInput? = nil, and: [ModelSaleBannerConditionInput?]? = nil, or: [ModelSaleBannerConditionInput?]? = nil, not: ModelSaleBannerConditionInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSaleBannerConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSaleBannerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSaleBannerConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSaleBannerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSaleBannerConditionInput? {
    get {
      return graphQLMap["not"] as! ModelSaleBannerConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct UpdateSaleBannerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: String? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String? {
    get {
      return graphQLMap["type"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DeleteSaleBannerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct CreateSupplierBenefitCodeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: String, version: Int? = nil, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var partnerSupplierBenefitCodesId: GraphQLID? {
    get {
      return graphQLMap["partnerSupplierBenefitCodesId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
    }
  }
}

public struct ModelSupplierBenefitCodeConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(type: ModelStringInput? = nil, and: [ModelSupplierBenefitCodeConditionInput?]? = nil, or: [ModelSupplierBenefitCodeConditionInput?]? = nil, not: ModelSupplierBenefitCodeConditionInput? = nil, deleted: ModelBooleanInput? = nil, partnerSupplierBenefitCodesId: ModelIDInput? = nil) {
    graphQLMap = ["type": type, "and": and, "or": or, "not": not, "_deleted": deleted, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId]
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSupplierBenefitCodeConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSupplierBenefitCodeConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSupplierBenefitCodeConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSupplierBenefitCodeConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSupplierBenefitCodeConditionInput? {
    get {
      return graphQLMap["not"] as! ModelSupplierBenefitCodeConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var partnerSupplierBenefitCodesId: ModelIDInput? {
    get {
      return graphQLMap["partnerSupplierBenefitCodesId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
    }
  }
}

public struct UpdateSupplierBenefitCodeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: String? = nil, version: Int? = nil, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String? {
    get {
      return graphQLMap["type"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }

  public var partnerSupplierBenefitCodesId: GraphQLID? {
    get {
      return graphQLMap["partnerSupplierBenefitCodesId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
    }
  }
}

public struct DeleteSupplierBenefitCodeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct CreateUSPSpecInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: String, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ModelUSPSpecConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(type: ModelStringInput? = nil, and: [ModelUSPSpecConditionInput?]? = nil, or: [ModelUSPSpecConditionInput?]? = nil, not: ModelUSPSpecConditionInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelUSPSpecConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUSPSpecConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUSPSpecConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUSPSpecConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUSPSpecConditionInput? {
    get {
      return graphQLMap["not"] as! ModelUSPSpecConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct UpdateUSPSpecInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: String? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String? {
    get {
      return graphQLMap["type"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DeleteUSPSpecInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct CreateSettingsMenuInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, type: String, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String {
    get {
      return graphQLMap["type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ModelSettingsMenuConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(type: ModelStringInput? = nil, and: [ModelSettingsMenuConditionInput?]? = nil, or: [ModelSettingsMenuConditionInput?]? = nil, not: ModelSettingsMenuConditionInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSettingsMenuConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSettingsMenuConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSettingsMenuConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSettingsMenuConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSettingsMenuConditionInput? {
    get {
      return graphQLMap["not"] as! ModelSettingsMenuConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct UpdateSettingsMenuInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, type: String? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "type": type, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: String? {
    get {
      return graphQLMap["type"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DeleteSettingsMenuInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ModelBookingFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, resId: ModelStringInput? = nil, username: ModelStringInput? = nil, and: [ModelBookingFilterInput?]? = nil, or: [ModelBookingFilterInput?]? = nil, not: ModelBookingFilterInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "resID": resId, "username": username, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var resId: ModelStringInput? {
    get {
      return graphQLMap["resID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "resID")
    }
  }

  public var username: ModelStringInput? {
    get {
      return graphQLMap["username"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var and: [ModelBookingFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelBookingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelBookingFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelBookingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelBookingFilterInput? {
    get {
      return graphQLMap["not"] as! ModelBookingFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelPartnerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, implementationId: ModelStringInput? = nil, name: ModelStringInput? = nil, tag: ModelStringInput? = nil, clientIds: ModelStringInput? = nil, enablePsd2WebForm: ModelBooleanInput? = nil, enablePrePaidExtras: ModelBooleanInput? = nil, enableZeroExcess: ModelBooleanInput? = nil, enableZeroExcessUpSell: ModelBooleanInput? = nil, enableQuickFilters: ModelBooleanInput? = nil, enableRatings: ModelBooleanInput? = nil, loyaltyRegex: ModelStringInput? = nil, enableCovidInsuranceMessage: ModelBooleanInput? = nil, imageBaseUrl: ModelStringInput? = nil, landingPageIcons: ModelStringInput? = nil, landingPageIconsDark: ModelStringInput? = nil, enableTracking: ModelBooleanInput? = nil, loyaltyProgramId: ModelStringInput? = nil, ratingType: ModelStringInput? = nil, enableLoyaltyRead: ModelBooleanInput? = nil, forceCalendarFirstDayOfWeek: ModelIntInput? = nil, enableGooglePay: ModelBooleanInput? = nil, enableApplePay: ModelBooleanInput? = nil, chipDiscountMechanicType: ModelStringInput? = nil, and: [ModelPartnerFilterInput?]? = nil, or: [ModelPartnerFilterInput?]? = nil, not: ModelPartnerFilterInput? = nil, deleted: ModelBooleanInput? = nil, partnerSaleBannerId: ModelIDInput? = nil, partnerUspSpecId: ModelIDInput? = nil, partnerSettingsMenuId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "and": and, "or": or, "not": not, "_deleted": deleted, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var implementationId: ModelStringInput? {
    get {
      return graphQLMap["implementationID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "implementationID")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var tag: ModelStringInput? {
    get {
      return graphQLMap["tag"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tag")
    }
  }

  public var clientIds: ModelStringInput? {
    get {
      return graphQLMap["clientIds"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientIds")
    }
  }

  public var enablePsd2WebForm: ModelBooleanInput? {
    get {
      return graphQLMap["enablePSD2WebForm"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePSD2WebForm")
    }
  }

  public var enablePrePaidExtras: ModelBooleanInput? {
    get {
      return graphQLMap["enablePrePaidExtras"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePrePaidExtras")
    }
  }

  public var enableZeroExcess: ModelBooleanInput? {
    get {
      return graphQLMap["enableZeroExcess"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcess")
    }
  }

  public var enableZeroExcessUpSell: ModelBooleanInput? {
    get {
      return graphQLMap["enableZeroExcessUpSell"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcessUpSell")
    }
  }

  public var enableQuickFilters: ModelBooleanInput? {
    get {
      return graphQLMap["enableQuickFilters"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableQuickFilters")
    }
  }

  public var enableRatings: ModelBooleanInput? {
    get {
      return graphQLMap["enableRatings"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableRatings")
    }
  }

  public var loyaltyRegex: ModelStringInput? {
    get {
      return graphQLMap["loyaltyRegex"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyRegex")
    }
  }

  public var enableCovidInsuranceMessage: ModelBooleanInput? {
    get {
      return graphQLMap["enableCovidInsuranceMessage"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
    }
  }

  public var imageBaseUrl: ModelStringInput? {
    get {
      return graphQLMap["imageBaseURL"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageBaseURL")
    }
  }

  public var landingPageIcons: ModelStringInput? {
    get {
      return graphQLMap["landingPageIcons"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIcons")
    }
  }

  public var landingPageIconsDark: ModelStringInput? {
    get {
      return graphQLMap["landingPageIconsDark"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIconsDark")
    }
  }

  public var enableTracking: ModelBooleanInput? {
    get {
      return graphQLMap["enableTracking"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableTracking")
    }
  }

  public var loyaltyProgramId: ModelStringInput? {
    get {
      return graphQLMap["loyaltyProgramId"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyProgramId")
    }
  }

  public var ratingType: ModelStringInput? {
    get {
      return graphQLMap["ratingType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ratingType")
    }
  }

  public var enableLoyaltyRead: ModelBooleanInput? {
    get {
      return graphQLMap["enableLoyaltyRead"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableLoyaltyRead")
    }
  }

  public var forceCalendarFirstDayOfWeek: ModelIntInput? {
    get {
      return graphQLMap["forceCalendarFirstDayOfWeek"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
    }
  }

  public var enableGooglePay: ModelBooleanInput? {
    get {
      return graphQLMap["enableGooglePay"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableGooglePay")
    }
  }

  public var enableApplePay: ModelBooleanInput? {
    get {
      return graphQLMap["enableApplePay"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableApplePay")
    }
  }

  public var chipDiscountMechanicType: ModelStringInput? {
    get {
      return graphQLMap["chipDiscountMechanicType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "chipDiscountMechanicType")
    }
  }

  public var and: [ModelPartnerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPartnerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPartnerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPartnerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPartnerFilterInput? {
    get {
      return graphQLMap["not"] as! ModelPartnerFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var partnerSaleBannerId: ModelIDInput? {
    get {
      return graphQLMap["partnerSaleBannerId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSaleBannerId")
    }
  }

  public var partnerUspSpecId: ModelIDInput? {
    get {
      return graphQLMap["partnerUspSpecId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerUspSpecId")
    }
  }

  public var partnerSettingsMenuId: ModelIDInput? {
    get {
      return graphQLMap["partnerSettingsMenuId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSettingsMenuId")
    }
  }
}

public struct ModelSaleBannerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, type: ModelStringInput? = nil, and: [ModelSaleBannerFilterInput?]? = nil, or: [ModelSaleBannerFilterInput?]? = nil, not: ModelSaleBannerFilterInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSaleBannerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSaleBannerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSaleBannerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSaleBannerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSaleBannerFilterInput? {
    get {
      return graphQLMap["not"] as! ModelSaleBannerFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSupplierBenefitCodeFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, type: ModelStringInput? = nil, and: [ModelSupplierBenefitCodeFilterInput?]? = nil, or: [ModelSupplierBenefitCodeFilterInput?]? = nil, not: ModelSupplierBenefitCodeFilterInput? = nil, deleted: ModelBooleanInput? = nil, partnerSupplierBenefitCodesId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "not": not, "_deleted": deleted, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSupplierBenefitCodeFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSupplierBenefitCodeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSupplierBenefitCodeFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSupplierBenefitCodeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSupplierBenefitCodeFilterInput? {
    get {
      return graphQLMap["not"] as! ModelSupplierBenefitCodeFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }

  public var partnerSupplierBenefitCodesId: ModelIDInput? {
    get {
      return graphQLMap["partnerSupplierBenefitCodesId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
    }
  }
}

public struct ModelUSPSpecFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, type: ModelStringInput? = nil, and: [ModelUSPSpecFilterInput?]? = nil, or: [ModelUSPSpecFilterInput?]? = nil, not: ModelUSPSpecFilterInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelUSPSpecFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUSPSpecFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUSPSpecFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUSPSpecFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUSPSpecFilterInput? {
    get {
      return graphQLMap["not"] as! ModelUSPSpecFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSettingsMenuFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, type: ModelStringInput? = nil, and: [ModelSettingsMenuFilterInput?]? = nil, or: [ModelSettingsMenuFilterInput?]? = nil, not: ModelSettingsMenuFilterInput? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "not": not, "_deleted": deleted]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelStringInput? {
    get {
      return graphQLMap["type"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSettingsMenuFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSettingsMenuFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSettingsMenuFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSettingsMenuFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelSettingsMenuFilterInput? {
    get {
      return graphQLMap["not"] as! ModelSettingsMenuFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionBookingFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, resId: ModelSubscriptionStringInput? = nil, username: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionBookingFilterInput?]? = nil, or: [ModelSubscriptionBookingFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "resID": resId, "username": username, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var resId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["resID"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "resID")
    }
  }

  public var username: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["username"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var and: [ModelSubscriptionBookingFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionBookingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionBookingFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionBookingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionPartnerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, implementationId: ModelSubscriptionStringInput? = nil, name: ModelSubscriptionStringInput? = nil, tag: ModelSubscriptionStringInput? = nil, clientIds: ModelSubscriptionStringInput? = nil, enablePsd2WebForm: ModelSubscriptionBooleanInput? = nil, enablePrePaidExtras: ModelSubscriptionBooleanInput? = nil, enableZeroExcess: ModelSubscriptionBooleanInput? = nil, enableZeroExcessUpSell: ModelSubscriptionBooleanInput? = nil, enableQuickFilters: ModelSubscriptionBooleanInput? = nil, enableRatings: ModelSubscriptionBooleanInput? = nil, loyaltyRegex: ModelSubscriptionStringInput? = nil, enableCovidInsuranceMessage: ModelSubscriptionBooleanInput? = nil, imageBaseUrl: ModelSubscriptionStringInput? = nil, landingPageIcons: ModelSubscriptionStringInput? = nil, landingPageIconsDark: ModelSubscriptionStringInput? = nil, enableTracking: ModelSubscriptionBooleanInput? = nil, loyaltyProgramId: ModelSubscriptionStringInput? = nil, ratingType: ModelSubscriptionStringInput? = nil, enableLoyaltyRead: ModelSubscriptionBooleanInput? = nil, forceCalendarFirstDayOfWeek: ModelSubscriptionIntInput? = nil, enableGooglePay: ModelSubscriptionBooleanInput? = nil, enableApplePay: ModelSubscriptionBooleanInput? = nil, chipDiscountMechanicType: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionPartnerFilterInput?]? = nil, or: [ModelSubscriptionPartnerFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var implementationId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["implementationID"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "implementationID")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var tag: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["tag"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tag")
    }
  }

  public var clientIds: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["clientIds"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "clientIds")
    }
  }

  public var enablePsd2WebForm: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enablePSD2WebForm"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePSD2WebForm")
    }
  }

  public var enablePrePaidExtras: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enablePrePaidExtras"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enablePrePaidExtras")
    }
  }

  public var enableZeroExcess: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableZeroExcess"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcess")
    }
  }

  public var enableZeroExcessUpSell: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableZeroExcessUpSell"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableZeroExcessUpSell")
    }
  }

  public var enableQuickFilters: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableQuickFilters"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableQuickFilters")
    }
  }

  public var enableRatings: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableRatings"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableRatings")
    }
  }

  public var loyaltyRegex: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["loyaltyRegex"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyRegex")
    }
  }

  public var enableCovidInsuranceMessage: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableCovidInsuranceMessage"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
    }
  }

  public var imageBaseUrl: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["imageBaseURL"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "imageBaseURL")
    }
  }

  public var landingPageIcons: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["landingPageIcons"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIcons")
    }
  }

  public var landingPageIconsDark: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["landingPageIconsDark"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "landingPageIconsDark")
    }
  }

  public var enableTracking: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableTracking"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableTracking")
    }
  }

  public var loyaltyProgramId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["loyaltyProgramId"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "loyaltyProgramId")
    }
  }

  public var ratingType: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["ratingType"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ratingType")
    }
  }

  public var enableLoyaltyRead: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableLoyaltyRead"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableLoyaltyRead")
    }
  }

  public var forceCalendarFirstDayOfWeek: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["forceCalendarFirstDayOfWeek"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
    }
  }

  public var enableGooglePay: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableGooglePay"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableGooglePay")
    }
  }

  public var enableApplePay: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["enableApplePay"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "enableApplePay")
    }
  }

  public var chipDiscountMechanicType: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["chipDiscountMechanicType"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "chipDiscountMechanicType")
    }
  }

  public var and: [ModelSubscriptionPartnerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionPartnerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionPartnerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionPartnerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil) {
    graphQLMap = ["ne": ne, "eq": eq]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }
}

public struct ModelSubscriptionIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, `in`: [Int?]? = nil, notIn: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "in": `in`, "notIn": notIn]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var `in`: [Int?]? {
    get {
      return graphQLMap["in"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [Int?]? {
    get {
      return graphQLMap["notIn"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionSaleBannerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, type: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionSaleBannerFilterInput?]? = nil, or: [ModelSubscriptionSaleBannerFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["type"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSubscriptionSaleBannerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionSaleBannerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionSaleBannerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionSaleBannerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionSupplierBenefitCodeFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, type: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionSupplierBenefitCodeFilterInput?]? = nil, or: [ModelSubscriptionSupplierBenefitCodeFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["type"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSubscriptionSupplierBenefitCodeFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionSupplierBenefitCodeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionSupplierBenefitCodeFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionSupplierBenefitCodeFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionUSPSpecFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, type: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionUSPSpecFilterInput?]? = nil, or: [ModelSubscriptionUSPSpecFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["type"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSubscriptionUSPSpecFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionUSPSpecFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionUSPSpecFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionUSPSpecFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public struct ModelSubscriptionSettingsMenuFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, type: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionSettingsMenuFilterInput?]? = nil, or: [ModelSubscriptionSettingsMenuFilterInput?]? = nil, deleted: ModelBooleanInput? = nil) {
    graphQLMap = ["id": id, "type": type, "and": and, "or": or, "_deleted": deleted]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["type"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }

  public var and: [ModelSubscriptionSettingsMenuFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionSettingsMenuFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionSettingsMenuFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionSettingsMenuFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var deleted: ModelBooleanInput? {
    get {
      return graphQLMap["_deleted"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_deleted")
    }
  }
}

public final class CreateBookingMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateBooking($input: CreateBookingInput!, $condition: ModelBookingConditionInput) {\n  createBooking(input: $input, condition: $condition) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateBookingInput
  public var condition: ModelBookingConditionInput?

  public init(input: CreateBookingInput, condition: ModelBookingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createBooking", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createBooking: CreateBooking? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createBooking": createBooking.flatMap { $0.snapshot }])
    }

    public var createBooking: CreateBooking? {
      get {
        return (snapshot["createBooking"] as? Snapshot).flatMap { CreateBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createBooking")
      }
    }

    public struct CreateBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateBookingMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateBooking($input: UpdateBookingInput!, $condition: ModelBookingConditionInput) {\n  updateBooking(input: $input, condition: $condition) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateBookingInput
  public var condition: ModelBookingConditionInput?

  public init(input: UpdateBookingInput, condition: ModelBookingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateBooking", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateBooking: UpdateBooking? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateBooking": updateBooking.flatMap { $0.snapshot }])
    }

    public var updateBooking: UpdateBooking? {
      get {
        return (snapshot["updateBooking"] as? Snapshot).flatMap { UpdateBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateBooking")
      }
    }

    public struct UpdateBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteBookingMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteBooking($input: DeleteBookingInput!, $condition: ModelBookingConditionInput) {\n  deleteBooking(input: $input, condition: $condition) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteBookingInput
  public var condition: ModelBookingConditionInput?

  public init(input: DeleteBookingInput, condition: ModelBookingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteBooking", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteBooking: DeleteBooking? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteBooking": deleteBooking.flatMap { $0.snapshot }])
    }

    public var deleteBooking: DeleteBooking? {
      get {
        return (snapshot["deleteBooking"] as? Snapshot).flatMap { DeleteBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteBooking")
      }
    }

    public struct DeleteBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreatePartnerMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreatePartner($input: CreatePartnerInput!, $condition: ModelPartnerConditionInput) {\n  createPartner(input: $input, condition: $condition) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var input: CreatePartnerInput
  public var condition: ModelPartnerConditionInput?

  public init(input: CreatePartnerInput, condition: ModelPartnerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createPartner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreatePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createPartner: CreatePartner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createPartner": createPartner.flatMap { $0.snapshot }])
    }

    public var createPartner: CreatePartner? {
      get {
        return (snapshot["createPartner"] as? Snapshot).flatMap { CreatePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createPartner")
      }
    }

    public struct CreatePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class UpdatePartnerMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdatePartner($input: UpdatePartnerInput!, $condition: ModelPartnerConditionInput) {\n  updatePartner(input: $input, condition: $condition) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var input: UpdatePartnerInput
  public var condition: ModelPartnerConditionInput?

  public init(input: UpdatePartnerInput, condition: ModelPartnerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updatePartner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdatePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updatePartner: UpdatePartner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updatePartner": updatePartner.flatMap { $0.snapshot }])
    }

    public var updatePartner: UpdatePartner? {
      get {
        return (snapshot["updatePartner"] as? Snapshot).flatMap { UpdatePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updatePartner")
      }
    }

    public struct UpdatePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class DeletePartnerMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeletePartner($input: DeletePartnerInput!, $condition: ModelPartnerConditionInput) {\n  deletePartner(input: $input, condition: $condition) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var input: DeletePartnerInput
  public var condition: ModelPartnerConditionInput?

  public init(input: DeletePartnerInput, condition: ModelPartnerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deletePartner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeletePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deletePartner: DeletePartner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePartner": deletePartner.flatMap { $0.snapshot }])
    }

    public var deletePartner: DeletePartner? {
      get {
        return (snapshot["deletePartner"] as? Snapshot).flatMap { DeletePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePartner")
      }
    }

    public struct DeletePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class CreateSaleBannerMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateSaleBanner($input: CreateSaleBannerInput!, $condition: ModelSaleBannerConditionInput) {\n  createSaleBanner(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateSaleBannerInput
  public var condition: ModelSaleBannerConditionInput?

  public init(input: CreateSaleBannerInput, condition: ModelSaleBannerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createSaleBanner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createSaleBanner: CreateSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createSaleBanner": createSaleBanner.flatMap { $0.snapshot }])
    }

    public var createSaleBanner: CreateSaleBanner? {
      get {
        return (snapshot["createSaleBanner"] as? Snapshot).flatMap { CreateSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createSaleBanner")
      }
    }

    public struct CreateSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateSaleBannerMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateSaleBanner($input: UpdateSaleBannerInput!, $condition: ModelSaleBannerConditionInput) {\n  updateSaleBanner(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateSaleBannerInput
  public var condition: ModelSaleBannerConditionInput?

  public init(input: UpdateSaleBannerInput, condition: ModelSaleBannerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateSaleBanner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateSaleBanner: UpdateSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateSaleBanner": updateSaleBanner.flatMap { $0.snapshot }])
    }

    public var updateSaleBanner: UpdateSaleBanner? {
      get {
        return (snapshot["updateSaleBanner"] as? Snapshot).flatMap { UpdateSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateSaleBanner")
      }
    }

    public struct UpdateSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteSaleBannerMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteSaleBanner($input: DeleteSaleBannerInput!, $condition: ModelSaleBannerConditionInput) {\n  deleteSaleBanner(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteSaleBannerInput
  public var condition: ModelSaleBannerConditionInput?

  public init(input: DeleteSaleBannerInput, condition: ModelSaleBannerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteSaleBanner", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteSaleBanner: DeleteSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteSaleBanner": deleteSaleBanner.flatMap { $0.snapshot }])
    }

    public var deleteSaleBanner: DeleteSaleBanner? {
      get {
        return (snapshot["deleteSaleBanner"] as? Snapshot).flatMap { DeleteSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteSaleBanner")
      }
    }

    public struct DeleteSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateSupplierBenefitCodeMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateSupplierBenefitCode($input: CreateSupplierBenefitCodeInput!, $condition: ModelSupplierBenefitCodeConditionInput) {\n  createSupplierBenefitCode(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var input: CreateSupplierBenefitCodeInput
  public var condition: ModelSupplierBenefitCodeConditionInput?

  public init(input: CreateSupplierBenefitCodeInput, condition: ModelSupplierBenefitCodeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createSupplierBenefitCode", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createSupplierBenefitCode: CreateSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createSupplierBenefitCode": createSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var createSupplierBenefitCode: CreateSupplierBenefitCode? {
      get {
        return (snapshot["createSupplierBenefitCode"] as? Snapshot).flatMap { CreateSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createSupplierBenefitCode")
      }
    }

    public struct CreateSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class UpdateSupplierBenefitCodeMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateSupplierBenefitCode($input: UpdateSupplierBenefitCodeInput!, $condition: ModelSupplierBenefitCodeConditionInput) {\n  updateSupplierBenefitCode(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var input: UpdateSupplierBenefitCodeInput
  public var condition: ModelSupplierBenefitCodeConditionInput?

  public init(input: UpdateSupplierBenefitCodeInput, condition: ModelSupplierBenefitCodeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateSupplierBenefitCode", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateSupplierBenefitCode: UpdateSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateSupplierBenefitCode": updateSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var updateSupplierBenefitCode: UpdateSupplierBenefitCode? {
      get {
        return (snapshot["updateSupplierBenefitCode"] as? Snapshot).flatMap { UpdateSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateSupplierBenefitCode")
      }
    }

    public struct UpdateSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class DeleteSupplierBenefitCodeMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteSupplierBenefitCode($input: DeleteSupplierBenefitCodeInput!, $condition: ModelSupplierBenefitCodeConditionInput) {\n  deleteSupplierBenefitCode(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var input: DeleteSupplierBenefitCodeInput
  public var condition: ModelSupplierBenefitCodeConditionInput?

  public init(input: DeleteSupplierBenefitCodeInput, condition: ModelSupplierBenefitCodeConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteSupplierBenefitCode", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteSupplierBenefitCode: DeleteSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteSupplierBenefitCode": deleteSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var deleteSupplierBenefitCode: DeleteSupplierBenefitCode? {
      get {
        return (snapshot["deleteSupplierBenefitCode"] as? Snapshot).flatMap { DeleteSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteSupplierBenefitCode")
      }
    }

    public struct DeleteSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class CreateUspSpecMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUSPSpec($input: CreateUSPSpecInput!, $condition: ModelUSPSpecConditionInput) {\n  createUSPSpec(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateUSPSpecInput
  public var condition: ModelUSPSpecConditionInput?

  public init(input: CreateUSPSpecInput, condition: ModelUSPSpecConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUSPSpec", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUspSpec: CreateUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUSPSpec": createUspSpec.flatMap { $0.snapshot }])
    }

    public var createUspSpec: CreateUspSpec? {
      get {
        return (snapshot["createUSPSpec"] as? Snapshot).flatMap { CreateUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUSPSpec")
      }
    }

    public struct CreateUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateUspSpecMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateUSPSpec($input: UpdateUSPSpecInput!, $condition: ModelUSPSpecConditionInput) {\n  updateUSPSpec(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateUSPSpecInput
  public var condition: ModelUSPSpecConditionInput?

  public init(input: UpdateUSPSpecInput, condition: ModelUSPSpecConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateUSPSpec", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateUspSpec: UpdateUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateUSPSpec": updateUspSpec.flatMap { $0.snapshot }])
    }

    public var updateUspSpec: UpdateUspSpec? {
      get {
        return (snapshot["updateUSPSpec"] as? Snapshot).flatMap { UpdateUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateUSPSpec")
      }
    }

    public struct UpdateUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteUspSpecMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteUSPSpec($input: DeleteUSPSpecInput!, $condition: ModelUSPSpecConditionInput) {\n  deleteUSPSpec(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteUSPSpecInput
  public var condition: ModelUSPSpecConditionInput?

  public init(input: DeleteUSPSpecInput, condition: ModelUSPSpecConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUSPSpec", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteUspSpec: DeleteUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteUSPSpec": deleteUspSpec.flatMap { $0.snapshot }])
    }

    public var deleteUspSpec: DeleteUspSpec? {
      get {
        return (snapshot["deleteUSPSpec"] as? Snapshot).flatMap { DeleteUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteUSPSpec")
      }
    }

    public struct DeleteUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class CreateSettingsMenuMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateSettingsMenu($input: CreateSettingsMenuInput!, $condition: ModelSettingsMenuConditionInput) {\n  createSettingsMenu(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: CreateSettingsMenuInput
  public var condition: ModelSettingsMenuConditionInput?

  public init(input: CreateSettingsMenuInput, condition: ModelSettingsMenuConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createSettingsMenu", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createSettingsMenu: CreateSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createSettingsMenu": createSettingsMenu.flatMap { $0.snapshot }])
    }

    public var createSettingsMenu: CreateSettingsMenu? {
      get {
        return (snapshot["createSettingsMenu"] as? Snapshot).flatMap { CreateSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createSettingsMenu")
      }
    }

    public struct CreateSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class UpdateSettingsMenuMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateSettingsMenu($input: UpdateSettingsMenuInput!, $condition: ModelSettingsMenuConditionInput) {\n  updateSettingsMenu(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: UpdateSettingsMenuInput
  public var condition: ModelSettingsMenuConditionInput?

  public init(input: UpdateSettingsMenuInput, condition: ModelSettingsMenuConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateSettingsMenu", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateSettingsMenu: UpdateSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateSettingsMenu": updateSettingsMenu.flatMap { $0.snapshot }])
    }

    public var updateSettingsMenu: UpdateSettingsMenu? {
      get {
        return (snapshot["updateSettingsMenu"] as? Snapshot).flatMap { UpdateSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateSettingsMenu")
      }
    }

    public struct UpdateSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class DeleteSettingsMenuMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteSettingsMenu($input: DeleteSettingsMenuInput!, $condition: ModelSettingsMenuConditionInput) {\n  deleteSettingsMenu(input: $input, condition: $condition) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var input: DeleteSettingsMenuInput
  public var condition: ModelSettingsMenuConditionInput?

  public init(input: DeleteSettingsMenuInput, condition: ModelSettingsMenuConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteSettingsMenu", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteSettingsMenu: DeleteSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteSettingsMenu": deleteSettingsMenu.flatMap { $0.snapshot }])
    }

    public var deleteSettingsMenu: DeleteSettingsMenu? {
      get {
        return (snapshot["deleteSettingsMenu"] as? Snapshot).flatMap { DeleteSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteSettingsMenu")
      }
    }

    public struct DeleteSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class GetBookingQuery: GraphQLQuery {
  public static let operationString =
    "query GetBooking($id: ID!) {\n  getBooking(id: $id) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getBooking", arguments: ["id": GraphQLVariable("id")], type: .object(GetBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getBooking: GetBooking? = nil) {
      self.init(snapshot: ["__typename": "Query", "getBooking": getBooking.flatMap { $0.snapshot }])
    }

    public var getBooking: GetBooking? {
      get {
        return (snapshot["getBooking"] as? Snapshot).flatMap { GetBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getBooking")
      }
    }

    public struct GetBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListBookingsQuery: GraphQLQuery {
  public static let operationString =
    "query ListBookings($filter: ModelBookingFilterInput, $limit: Int, $nextToken: String) {\n  listBookings(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      resID\n      username\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelBookingFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelBookingFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listBookings", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listBookings: ListBooking? = nil) {
      self.init(snapshot: ["__typename": "Query", "listBookings": listBookings.flatMap { $0.snapshot }])
    }

    public var listBookings: ListBooking? {
      get {
        return (snapshot["listBookings"] as? Snapshot).flatMap { ListBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listBookings")
      }
    }

    public struct ListBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelBookingConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelBookingConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Booking"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("resID", type: .nonNull(.scalar(String.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var resId: String {
          get {
            return snapshot["resID"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "resID")
          }
        }

        public var username: String {
          get {
            return snapshot["username"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "username")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class SyncBookingsQuery: GraphQLQuery {
  public static let operationString =
    "query SyncBookings($filter: ModelBookingFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncBookings(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      resID\n      username\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelBookingFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelBookingFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncBookings", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncBookings: SyncBooking? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncBookings": syncBookings.flatMap { $0.snapshot }])
    }

    public var syncBookings: SyncBooking? {
      get {
        return (snapshot["syncBookings"] as? Snapshot).flatMap { SyncBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncBookings")
      }
    }

    public struct SyncBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelBookingConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelBookingConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Booking"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("resID", type: .nonNull(.scalar(String.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var resId: String {
          get {
            return snapshot["resID"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "resID")
          }
        }

        public var username: String {
          get {
            return snapshot["username"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "username")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetPartnerQuery: GraphQLQuery {
  public static let operationString =
    "query GetPartner($id: ID!) {\n  getPartner(id: $id) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPartner", arguments: ["id": GraphQLVariable("id")], type: .object(GetPartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPartner: GetPartner? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPartner": getPartner.flatMap { $0.snapshot }])
    }

    public var getPartner: GetPartner? {
      get {
        return (snapshot["getPartner"] as? Snapshot).flatMap { GetPartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPartner")
      }
    }

    public struct GetPartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class ListPartnersQuery: GraphQLQuery {
  public static let operationString =
    "query ListPartners($filter: ModelPartnerFilterInput, $limit: Int, $nextToken: String) {\n  listPartners(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      implementationID\n      name\n      tag\n      clientIds\n      enablePSD2WebForm\n      enablePrePaidExtras\n      enableZeroExcess\n      enableZeroExcessUpSell\n      enableQuickFilters\n      enableRatings\n      loyaltyRegex\n      enableCovidInsuranceMessage\n      imageBaseURL\n      landingPageIcons\n      landingPageIconsDark\n      enableTracking\n      loyaltyProgramId\n      ratingType\n      enableLoyaltyRead\n      forceCalendarFirstDayOfWeek\n      enableGooglePay\n      enableApplePay\n      chipDiscountMechanicType\n      saleBanner {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      supplierBenefitCodes {\n        __typename\n        nextToken\n        startedAt\n      }\n      uspSpec {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      settingsMenu {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n      partnerSaleBannerId\n      partnerUspSpecId\n      partnerSettingsMenuId\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelPartnerFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelPartnerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listPartners", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListPartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listPartners: ListPartner? = nil) {
      self.init(snapshot: ["__typename": "Query", "listPartners": listPartners.flatMap { $0.snapshot }])
    }

    public var listPartners: ListPartner? {
      get {
        return (snapshot["listPartners"] as? Snapshot).flatMap { ListPartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listPartners")
      }
    }

    public struct ListPartner: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelPartnerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelPartnerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Partner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("tag", type: .scalar(String.self)),
          GraphQLField("clientIds", type: .list(.scalar(String.self))),
          GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
          GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
          GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
          GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
          GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
          GraphQLField("enableRatings", type: .scalar(Bool.self)),
          GraphQLField("loyaltyRegex", type: .scalar(String.self)),
          GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
          GraphQLField("imageBaseURL", type: .scalar(String.self)),
          GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
          GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
          GraphQLField("enableTracking", type: .scalar(Bool.self)),
          GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
          GraphQLField("ratingType", type: .scalar(String.self)),
          GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
          GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
          GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
          GraphQLField("enableApplePay", type: .scalar(Bool.self)),
          GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
          GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
          GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
          GraphQLField("uspSpec", type: .object(UspSpec.selections)),
          GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
          GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
          GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var implementationId: String {
          get {
            return snapshot["implementationID"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "implementationID")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var tag: String? {
          get {
            return snapshot["tag"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "tag")
          }
        }

        public var clientIds: [String?]? {
          get {
            return snapshot["clientIds"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientIds")
          }
        }

        public var enablePsd2WebForm: Bool? {
          get {
            return snapshot["enablePSD2WebForm"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
          }
        }

        public var enablePrePaidExtras: Bool? {
          get {
            return snapshot["enablePrePaidExtras"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
          }
        }

        public var enableZeroExcess: Bool? {
          get {
            return snapshot["enableZeroExcess"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableZeroExcess")
          }
        }

        public var enableZeroExcessUpSell: Bool? {
          get {
            return snapshot["enableZeroExcessUpSell"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
          }
        }

        public var enableQuickFilters: Bool? {
          get {
            return snapshot["enableQuickFilters"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableQuickFilters")
          }
        }

        public var enableRatings: Bool? {
          get {
            return snapshot["enableRatings"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableRatings")
          }
        }

        public var loyaltyRegex: String? {
          get {
            return snapshot["loyaltyRegex"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "loyaltyRegex")
          }
        }

        public var enableCovidInsuranceMessage: Bool? {
          get {
            return snapshot["enableCovidInsuranceMessage"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
          }
        }

        public var imageBaseUrl: String? {
          get {
            return snapshot["imageBaseURL"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "imageBaseURL")
          }
        }

        public var landingPageIcons: [String?]? {
          get {
            return snapshot["landingPageIcons"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "landingPageIcons")
          }
        }

        public var landingPageIconsDark: [String?]? {
          get {
            return snapshot["landingPageIconsDark"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
          }
        }

        public var enableTracking: Bool? {
          get {
            return snapshot["enableTracking"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableTracking")
          }
        }

        public var loyaltyProgramId: String? {
          get {
            return snapshot["loyaltyProgramId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
          }
        }

        public var ratingType: String? {
          get {
            return snapshot["ratingType"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "ratingType")
          }
        }

        public var enableLoyaltyRead: Bool? {
          get {
            return snapshot["enableLoyaltyRead"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
          }
        }

        public var forceCalendarFirstDayOfWeek: Int? {
          get {
            return snapshot["forceCalendarFirstDayOfWeek"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
          }
        }

        public var enableGooglePay: Bool? {
          get {
            return snapshot["enableGooglePay"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableGooglePay")
          }
        }

        public var enableApplePay: Bool? {
          get {
            return snapshot["enableApplePay"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableApplePay")
          }
        }

        public var chipDiscountMechanicType: String? {
          get {
            return snapshot["chipDiscountMechanicType"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
          }
        }

        public var saleBanner: SaleBanner? {
          get {
            return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
          }
        }

        public var supplierBenefitCodes: SupplierBenefitCode? {
          get {
            return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
          }
        }

        public var uspSpec: UspSpec? {
          get {
            return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
          }
        }

        public var settingsMenu: SettingsMenu? {
          get {
            return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var partnerSaleBannerId: GraphQLID? {
          get {
            return snapshot["partnerSaleBannerId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
          }
        }

        public var partnerUspSpecId: GraphQLID? {
          get {
            return snapshot["partnerUspSpecId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
          }
        }

        public var partnerSettingsMenuId: GraphQLID? {
          get {
            return snapshot["partnerSettingsMenuId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
          }
        }

        public struct SaleBanner: GraphQLSelectionSet {
          public static let possibleTypes = ["SaleBanner"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }

        public struct SupplierBenefitCode: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
            GraphQLField("startedAt", type: .scalar(Int.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil, startedAt: Int? = nil) {
            self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "nextToken": nextToken, "startedAt": startedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }

          public var startedAt: Int? {
            get {
              return snapshot["startedAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "startedAt")
            }
          }
        }

        public struct UspSpec: GraphQLSelectionSet {
          public static let possibleTypes = ["USPSpec"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }

        public struct SettingsMenu: GraphQLSelectionSet {
          public static let possibleTypes = ["SettingsMenu"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }
      }
    }
  }
}

public final class SyncPartnersQuery: GraphQLQuery {
  public static let operationString =
    "query SyncPartners($filter: ModelPartnerFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncPartners(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      implementationID\n      name\n      tag\n      clientIds\n      enablePSD2WebForm\n      enablePrePaidExtras\n      enableZeroExcess\n      enableZeroExcessUpSell\n      enableQuickFilters\n      enableRatings\n      loyaltyRegex\n      enableCovidInsuranceMessage\n      imageBaseURL\n      landingPageIcons\n      landingPageIconsDark\n      enableTracking\n      loyaltyProgramId\n      ratingType\n      enableLoyaltyRead\n      forceCalendarFirstDayOfWeek\n      enableGooglePay\n      enableApplePay\n      chipDiscountMechanicType\n      saleBanner {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      supplierBenefitCodes {\n        __typename\n        nextToken\n        startedAt\n      }\n      uspSpec {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      settingsMenu {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n      }\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n      partnerSaleBannerId\n      partnerUspSpecId\n      partnerSettingsMenuId\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelPartnerFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelPartnerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncPartners", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncPartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncPartners: SyncPartner? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncPartners": syncPartners.flatMap { $0.snapshot }])
    }

    public var syncPartners: SyncPartner? {
      get {
        return (snapshot["syncPartners"] as? Snapshot).flatMap { SyncPartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncPartners")
      }
    }

    public struct SyncPartner: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelPartnerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelPartnerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Partner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("tag", type: .scalar(String.self)),
          GraphQLField("clientIds", type: .list(.scalar(String.self))),
          GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
          GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
          GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
          GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
          GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
          GraphQLField("enableRatings", type: .scalar(Bool.self)),
          GraphQLField("loyaltyRegex", type: .scalar(String.self)),
          GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
          GraphQLField("imageBaseURL", type: .scalar(String.self)),
          GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
          GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
          GraphQLField("enableTracking", type: .scalar(Bool.self)),
          GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
          GraphQLField("ratingType", type: .scalar(String.self)),
          GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
          GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
          GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
          GraphQLField("enableApplePay", type: .scalar(Bool.self)),
          GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
          GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
          GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
          GraphQLField("uspSpec", type: .object(UspSpec.selections)),
          GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
          GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
          GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var implementationId: String {
          get {
            return snapshot["implementationID"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "implementationID")
          }
        }

        public var name: String? {
          get {
            return snapshot["name"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var tag: String? {
          get {
            return snapshot["tag"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "tag")
          }
        }

        public var clientIds: [String?]? {
          get {
            return snapshot["clientIds"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "clientIds")
          }
        }

        public var enablePsd2WebForm: Bool? {
          get {
            return snapshot["enablePSD2WebForm"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
          }
        }

        public var enablePrePaidExtras: Bool? {
          get {
            return snapshot["enablePrePaidExtras"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
          }
        }

        public var enableZeroExcess: Bool? {
          get {
            return snapshot["enableZeroExcess"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableZeroExcess")
          }
        }

        public var enableZeroExcessUpSell: Bool? {
          get {
            return snapshot["enableZeroExcessUpSell"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
          }
        }

        public var enableQuickFilters: Bool? {
          get {
            return snapshot["enableQuickFilters"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableQuickFilters")
          }
        }

        public var enableRatings: Bool? {
          get {
            return snapshot["enableRatings"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableRatings")
          }
        }

        public var loyaltyRegex: String? {
          get {
            return snapshot["loyaltyRegex"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "loyaltyRegex")
          }
        }

        public var enableCovidInsuranceMessage: Bool? {
          get {
            return snapshot["enableCovidInsuranceMessage"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
          }
        }

        public var imageBaseUrl: String? {
          get {
            return snapshot["imageBaseURL"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "imageBaseURL")
          }
        }

        public var landingPageIcons: [String?]? {
          get {
            return snapshot["landingPageIcons"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "landingPageIcons")
          }
        }

        public var landingPageIconsDark: [String?]? {
          get {
            return snapshot["landingPageIconsDark"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
          }
        }

        public var enableTracking: Bool? {
          get {
            return snapshot["enableTracking"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableTracking")
          }
        }

        public var loyaltyProgramId: String? {
          get {
            return snapshot["loyaltyProgramId"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
          }
        }

        public var ratingType: String? {
          get {
            return snapshot["ratingType"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "ratingType")
          }
        }

        public var enableLoyaltyRead: Bool? {
          get {
            return snapshot["enableLoyaltyRead"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
          }
        }

        public var forceCalendarFirstDayOfWeek: Int? {
          get {
            return snapshot["forceCalendarFirstDayOfWeek"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
          }
        }

        public var enableGooglePay: Bool? {
          get {
            return snapshot["enableGooglePay"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableGooglePay")
          }
        }

        public var enableApplePay: Bool? {
          get {
            return snapshot["enableApplePay"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "enableApplePay")
          }
        }

        public var chipDiscountMechanicType: String? {
          get {
            return snapshot["chipDiscountMechanicType"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
          }
        }

        public var saleBanner: SaleBanner? {
          get {
            return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
          }
        }

        public var supplierBenefitCodes: SupplierBenefitCode? {
          get {
            return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
          }
        }

        public var uspSpec: UspSpec? {
          get {
            return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
          }
        }

        public var settingsMenu: SettingsMenu? {
          get {
            return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var partnerSaleBannerId: GraphQLID? {
          get {
            return snapshot["partnerSaleBannerId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
          }
        }

        public var partnerUspSpecId: GraphQLID? {
          get {
            return snapshot["partnerUspSpecId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
          }
        }

        public var partnerSettingsMenuId: GraphQLID? {
          get {
            return snapshot["partnerSettingsMenuId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
          }
        }

        public struct SaleBanner: GraphQLSelectionSet {
          public static let possibleTypes = ["SaleBanner"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }

        public struct SupplierBenefitCode: GraphQLSelectionSet {
          public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nextToken", type: .scalar(String.self)),
            GraphQLField("startedAt", type: .scalar(Int.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(nextToken: String? = nil, startedAt: Int? = nil) {
            self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "nextToken": nextToken, "startedAt": startedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var nextToken: String? {
            get {
              return snapshot["nextToken"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "nextToken")
            }
          }

          public var startedAt: Int? {
            get {
              return snapshot["startedAt"] as? Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "startedAt")
            }
          }
        }

        public struct UspSpec: GraphQLSelectionSet {
          public static let possibleTypes = ["USPSpec"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }

        public struct SettingsMenu: GraphQLSelectionSet {
          public static let possibleTypes = ["SettingsMenu"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
            self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }
        }
      }
    }
  }
}

public final class GetSaleBannerQuery: GraphQLQuery {
  public static let operationString =
    "query GetSaleBanner($id: ID!) {\n  getSaleBanner(id: $id) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getSaleBanner", arguments: ["id": GraphQLVariable("id")], type: .object(GetSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getSaleBanner: GetSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Query", "getSaleBanner": getSaleBanner.flatMap { $0.snapshot }])
    }

    public var getSaleBanner: GetSaleBanner? {
      get {
        return (snapshot["getSaleBanner"] as? Snapshot).flatMap { GetSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getSaleBanner")
      }
    }

    public struct GetSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListSaleBannersQuery: GraphQLQuery {
  public static let operationString =
    "query ListSaleBanners($filter: ModelSaleBannerFilterInput, $limit: Int, $nextToken: String) {\n  listSaleBanners(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSaleBannerFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelSaleBannerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listSaleBanners", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listSaleBanners: ListSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Query", "listSaleBanners": listSaleBanners.flatMap { $0.snapshot }])
    }

    public var listSaleBanners: ListSaleBanner? {
      get {
        return (snapshot["listSaleBanners"] as? Snapshot).flatMap { ListSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listSaleBanners")
      }
    }

    public struct ListSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSaleBannerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSaleBannerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class SyncSaleBannersQuery: GraphQLQuery {
  public static let operationString =
    "query SyncSaleBanners($filter: ModelSaleBannerFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncSaleBanners(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSaleBannerFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelSaleBannerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncSaleBanners", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncSaleBanners: SyncSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncSaleBanners": syncSaleBanners.flatMap { $0.snapshot }])
    }

    public var syncSaleBanners: SyncSaleBanner? {
      get {
        return (snapshot["syncSaleBanners"] as? Snapshot).flatMap { SyncSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncSaleBanners")
      }
    }

    public struct SyncSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSaleBannerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSaleBannerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetSupplierBenefitCodeQuery: GraphQLQuery {
  public static let operationString =
    "query GetSupplierBenefitCode($id: ID!) {\n  getSupplierBenefitCode(id: $id) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getSupplierBenefitCode", arguments: ["id": GraphQLVariable("id")], type: .object(GetSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getSupplierBenefitCode: GetSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Query", "getSupplierBenefitCode": getSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var getSupplierBenefitCode: GetSupplierBenefitCode? {
      get {
        return (snapshot["getSupplierBenefitCode"] as? Snapshot).flatMap { GetSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getSupplierBenefitCode")
      }
    }

    public struct GetSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class ListSupplierBenefitCodesQuery: GraphQLQuery {
  public static let operationString =
    "query ListSupplierBenefitCodes($filter: ModelSupplierBenefitCodeFilterInput, $limit: Int, $nextToken: String) {\n  listSupplierBenefitCodes(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n      partnerSupplierBenefitCodesId\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSupplierBenefitCodeFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelSupplierBenefitCodeFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listSupplierBenefitCodes", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listSupplierBenefitCodes: ListSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Query", "listSupplierBenefitCodes": listSupplierBenefitCodes.flatMap { $0.snapshot }])
    }

    public var listSupplierBenefitCodes: ListSupplierBenefitCode? {
      get {
        return (snapshot["listSupplierBenefitCodes"] as? Snapshot).flatMap { ListSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listSupplierBenefitCodes")
      }
    }

    public struct ListSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SupplierBenefitCode"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var partnerSupplierBenefitCodesId: GraphQLID? {
          get {
            return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
          }
        }
      }
    }
  }
}

public final class SyncSupplierBenefitCodesQuery: GraphQLQuery {
  public static let operationString =
    "query SyncSupplierBenefitCodes($filter: ModelSupplierBenefitCodeFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncSupplierBenefitCodes(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n      partnerSupplierBenefitCodesId\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSupplierBenefitCodeFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelSupplierBenefitCodeFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncSupplierBenefitCodes", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncSupplierBenefitCodes: SyncSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncSupplierBenefitCodes": syncSupplierBenefitCodes.flatMap { $0.snapshot }])
    }

    public var syncSupplierBenefitCodes: SyncSupplierBenefitCode? {
      get {
        return (snapshot["syncSupplierBenefitCodes"] as? Snapshot).flatMap { SyncSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncSupplierBenefitCodes")
      }
    }

    public struct SyncSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SupplierBenefitCode"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var partnerSupplierBenefitCodesId: GraphQLID? {
          get {
            return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
          }
        }
      }
    }
  }
}

public final class GetUspSpecQuery: GraphQLQuery {
  public static let operationString =
    "query GetUSPSpec($id: ID!) {\n  getUSPSpec(id: $id) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getUSPSpec", arguments: ["id": GraphQLVariable("id")], type: .object(GetUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getUspSpec: GetUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Query", "getUSPSpec": getUspSpec.flatMap { $0.snapshot }])
    }

    public var getUspSpec: GetUspSpec? {
      get {
        return (snapshot["getUSPSpec"] as? Snapshot).flatMap { GetUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getUSPSpec")
      }
    }

    public struct GetUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListUspSpecsQuery: GraphQLQuery {
  public static let operationString =
    "query ListUSPSpecs($filter: ModelUSPSpecFilterInput, $limit: Int, $nextToken: String) {\n  listUSPSpecs(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelUSPSpecFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelUSPSpecFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listUSPSpecs", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listUspSpecs: ListUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Query", "listUSPSpecs": listUspSpecs.flatMap { $0.snapshot }])
    }

    public var listUspSpecs: ListUspSpec? {
      get {
        return (snapshot["listUSPSpecs"] as? Snapshot).flatMap { ListUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listUSPSpecs")
      }
    }

    public struct ListUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelUSPSpecConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelUSPSpecConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class SyncUspSpecsQuery: GraphQLQuery {
  public static let operationString =
    "query SyncUSPSpecs($filter: ModelUSPSpecFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncUSPSpecs(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelUSPSpecFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelUSPSpecFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncUSPSpecs", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncUspSpecs: SyncUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncUSPSpecs": syncUspSpecs.flatMap { $0.snapshot }])
    }

    public var syncUspSpecs: SyncUspSpec? {
      get {
        return (snapshot["syncUSPSpecs"] as? Snapshot).flatMap { SyncUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncUSPSpecs")
      }
    }

    public struct SyncUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelUSPSpecConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelUSPSpecConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class GetSettingsMenuQuery: GraphQLQuery {
  public static let operationString =
    "query GetSettingsMenu($id: ID!) {\n  getSettingsMenu(id: $id) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getSettingsMenu", arguments: ["id": GraphQLVariable("id")], type: .object(GetSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getSettingsMenu: GetSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Query", "getSettingsMenu": getSettingsMenu.flatMap { $0.snapshot }])
    }

    public var getSettingsMenu: GetSettingsMenu? {
      get {
        return (snapshot["getSettingsMenu"] as? Snapshot).flatMap { GetSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getSettingsMenu")
      }
    }

    public struct GetSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class ListSettingsMenusQuery: GraphQLQuery {
  public static let operationString =
    "query ListSettingsMenus($filter: ModelSettingsMenuFilterInput, $limit: Int, $nextToken: String) {\n  listSettingsMenus(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSettingsMenuFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelSettingsMenuFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listSettingsMenus", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listSettingsMenus: ListSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Query", "listSettingsMenus": listSettingsMenus.flatMap { $0.snapshot }])
    }

    public var listSettingsMenus: ListSettingsMenu? {
      get {
        return (snapshot["listSettingsMenus"] as? Snapshot).flatMap { ListSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listSettingsMenus")
      }
    }

    public struct ListSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSettingsMenuConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSettingsMenuConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class SyncSettingsMenusQuery: GraphQLQuery {
  public static let operationString =
    "query SyncSettingsMenus($filter: ModelSettingsMenuFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncSettingsMenus(\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    lastSync: $lastSync\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelSettingsMenuFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelSettingsMenuFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncSettingsMenus", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncSettingsMenus: SyncSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncSettingsMenus": syncSettingsMenus.flatMap { $0.snapshot }])
    }

    public var syncSettingsMenus: SyncSettingsMenu? {
      get {
        return (snapshot["syncSettingsMenus"] as? Snapshot).flatMap { SyncSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncSettingsMenus")
      }
    }

    public struct SyncSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelSettingsMenuConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelSettingsMenuConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateBookingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateBooking($filter: ModelSubscriptionBookingFilterInput) {\n  onCreateBooking(filter: $filter) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionBookingFilterInput?

  public init(filter: ModelSubscriptionBookingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateBooking", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateBooking: OnCreateBooking? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateBooking": onCreateBooking.flatMap { $0.snapshot }])
    }

    public var onCreateBooking: OnCreateBooking? {
      get {
        return (snapshot["onCreateBooking"] as? Snapshot).flatMap { OnCreateBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateBooking")
      }
    }

    public struct OnCreateBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateBookingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateBooking($filter: ModelSubscriptionBookingFilterInput) {\n  onUpdateBooking(filter: $filter) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionBookingFilterInput?

  public init(filter: ModelSubscriptionBookingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateBooking", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateBooking: OnUpdateBooking? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateBooking": onUpdateBooking.flatMap { $0.snapshot }])
    }

    public var onUpdateBooking: OnUpdateBooking? {
      get {
        return (snapshot["onUpdateBooking"] as? Snapshot).flatMap { OnUpdateBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateBooking")
      }
    }

    public struct OnUpdateBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteBookingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteBooking($filter: ModelSubscriptionBookingFilterInput) {\n  onDeleteBooking(filter: $filter) {\n    __typename\n    id\n    resID\n    username\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionBookingFilterInput?

  public init(filter: ModelSubscriptionBookingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteBooking", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteBooking.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteBooking: OnDeleteBooking? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteBooking": onDeleteBooking.flatMap { $0.snapshot }])
    }

    public var onDeleteBooking: OnDeleteBooking? {
      get {
        return (snapshot["onDeleteBooking"] as? Snapshot).flatMap { OnDeleteBooking(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteBooking")
      }
    }

    public struct OnDeleteBooking: GraphQLSelectionSet {
      public static let possibleTypes = ["Booking"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("resID", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, resId: String, username: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "Booking", "id": id, "resID": resId, "username": username, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var resId: String {
        get {
          return snapshot["resID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "resID")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreatePartnerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreatePartner($filter: ModelSubscriptionPartnerFilterInput) {\n  onCreatePartner(filter: $filter) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var filter: ModelSubscriptionPartnerFilterInput?

  public init(filter: ModelSubscriptionPartnerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreatePartner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreatePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreatePartner: OnCreatePartner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreatePartner": onCreatePartner.flatMap { $0.snapshot }])
    }

    public var onCreatePartner: OnCreatePartner? {
      get {
        return (snapshot["onCreatePartner"] as? Snapshot).flatMap { OnCreatePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreatePartner")
      }
    }

    public struct OnCreatePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdatePartnerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdatePartner($filter: ModelSubscriptionPartnerFilterInput) {\n  onUpdatePartner(filter: $filter) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var filter: ModelSubscriptionPartnerFilterInput?

  public init(filter: ModelSubscriptionPartnerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdatePartner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdatePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdatePartner: OnUpdatePartner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdatePartner": onUpdatePartner.flatMap { $0.snapshot }])
    }

    public var onUpdatePartner: OnUpdatePartner? {
      get {
        return (snapshot["onUpdatePartner"] as? Snapshot).flatMap { OnUpdatePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdatePartner")
      }
    }

    public struct OnUpdatePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class OnDeletePartnerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeletePartner($filter: ModelSubscriptionPartnerFilterInput) {\n  onDeletePartner(filter: $filter) {\n    __typename\n    id\n    implementationID\n    name\n    tag\n    clientIds\n    enablePSD2WebForm\n    enablePrePaidExtras\n    enableZeroExcess\n    enableZeroExcessUpSell\n    enableQuickFilters\n    enableRatings\n    loyaltyRegex\n    enableCovidInsuranceMessage\n    imageBaseURL\n    landingPageIcons\n    landingPageIconsDark\n    enableTracking\n    loyaltyProgramId\n    ratingType\n    enableLoyaltyRead\n    forceCalendarFirstDayOfWeek\n    enableGooglePay\n    enableApplePay\n    chipDiscountMechanicType\n    saleBanner {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    supplierBenefitCodes {\n      __typename\n      items {\n        __typename\n        id\n        type\n        createdAt\n        updatedAt\n        _version\n        _deleted\n        _lastChangedAt\n        partnerSupplierBenefitCodesId\n      }\n      nextToken\n      startedAt\n    }\n    uspSpec {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    settingsMenu {\n      __typename\n      id\n      type\n      createdAt\n      updatedAt\n      _version\n      _deleted\n      _lastChangedAt\n    }\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSaleBannerId\n    partnerUspSpecId\n    partnerSettingsMenuId\n  }\n}"

  public var filter: ModelSubscriptionPartnerFilterInput?

  public init(filter: ModelSubscriptionPartnerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeletePartner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeletePartner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeletePartner: OnDeletePartner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeletePartner": onDeletePartner.flatMap { $0.snapshot }])
    }

    public var onDeletePartner: OnDeletePartner? {
      get {
        return (snapshot["onDeletePartner"] as? Snapshot).flatMap { OnDeletePartner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeletePartner")
      }
    }

    public struct OnDeletePartner: GraphQLSelectionSet {
      public static let possibleTypes = ["Partner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("implementationID", type: .nonNull(.scalar(String.self))),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("tag", type: .scalar(String.self)),
        GraphQLField("clientIds", type: .list(.scalar(String.self))),
        GraphQLField("enablePSD2WebForm", type: .scalar(Bool.self)),
        GraphQLField("enablePrePaidExtras", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcess", type: .scalar(Bool.self)),
        GraphQLField("enableZeroExcessUpSell", type: .scalar(Bool.self)),
        GraphQLField("enableQuickFilters", type: .scalar(Bool.self)),
        GraphQLField("enableRatings", type: .scalar(Bool.self)),
        GraphQLField("loyaltyRegex", type: .scalar(String.self)),
        GraphQLField("enableCovidInsuranceMessage", type: .scalar(Bool.self)),
        GraphQLField("imageBaseURL", type: .scalar(String.self)),
        GraphQLField("landingPageIcons", type: .list(.scalar(String.self))),
        GraphQLField("landingPageIconsDark", type: .list(.scalar(String.self))),
        GraphQLField("enableTracking", type: .scalar(Bool.self)),
        GraphQLField("loyaltyProgramId", type: .scalar(String.self)),
        GraphQLField("ratingType", type: .scalar(String.self)),
        GraphQLField("enableLoyaltyRead", type: .scalar(Bool.self)),
        GraphQLField("forceCalendarFirstDayOfWeek", type: .scalar(Int.self)),
        GraphQLField("enableGooglePay", type: .scalar(Bool.self)),
        GraphQLField("enableApplePay", type: .scalar(Bool.self)),
        GraphQLField("chipDiscountMechanicType", type: .scalar(String.self)),
        GraphQLField("saleBanner", type: .object(SaleBanner.selections)),
        GraphQLField("supplierBenefitCodes", type: .object(SupplierBenefitCode.selections)),
        GraphQLField("uspSpec", type: .object(UspSpec.selections)),
        GraphQLField("settingsMenu", type: .object(SettingsMenu.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSaleBannerId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerUspSpecId", type: .scalar(GraphQLID.self)),
        GraphQLField("partnerSettingsMenuId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, implementationId: String, name: String? = nil, tag: String? = nil, clientIds: [String?]? = nil, enablePsd2WebForm: Bool? = nil, enablePrePaidExtras: Bool? = nil, enableZeroExcess: Bool? = nil, enableZeroExcessUpSell: Bool? = nil, enableQuickFilters: Bool? = nil, enableRatings: Bool? = nil, loyaltyRegex: String? = nil, enableCovidInsuranceMessage: Bool? = nil, imageBaseUrl: String? = nil, landingPageIcons: [String?]? = nil, landingPageIconsDark: [String?]? = nil, enableTracking: Bool? = nil, loyaltyProgramId: String? = nil, ratingType: String? = nil, enableLoyaltyRead: Bool? = nil, forceCalendarFirstDayOfWeek: Int? = nil, enableGooglePay: Bool? = nil, enableApplePay: Bool? = nil, chipDiscountMechanicType: String? = nil, saleBanner: SaleBanner? = nil, supplierBenefitCodes: SupplierBenefitCode? = nil, uspSpec: UspSpec? = nil, settingsMenu: SettingsMenu? = nil, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSaleBannerId: GraphQLID? = nil, partnerUspSpecId: GraphQLID? = nil, partnerSettingsMenuId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "Partner", "id": id, "implementationID": implementationId, "name": name, "tag": tag, "clientIds": clientIds, "enablePSD2WebForm": enablePsd2WebForm, "enablePrePaidExtras": enablePrePaidExtras, "enableZeroExcess": enableZeroExcess, "enableZeroExcessUpSell": enableZeroExcessUpSell, "enableQuickFilters": enableQuickFilters, "enableRatings": enableRatings, "loyaltyRegex": loyaltyRegex, "enableCovidInsuranceMessage": enableCovidInsuranceMessage, "imageBaseURL": imageBaseUrl, "landingPageIcons": landingPageIcons, "landingPageIconsDark": landingPageIconsDark, "enableTracking": enableTracking, "loyaltyProgramId": loyaltyProgramId, "ratingType": ratingType, "enableLoyaltyRead": enableLoyaltyRead, "forceCalendarFirstDayOfWeek": forceCalendarFirstDayOfWeek, "enableGooglePay": enableGooglePay, "enableApplePay": enableApplePay, "chipDiscountMechanicType": chipDiscountMechanicType, "saleBanner": saleBanner.flatMap { $0.snapshot }, "supplierBenefitCodes": supplierBenefitCodes.flatMap { $0.snapshot }, "uspSpec": uspSpec.flatMap { $0.snapshot }, "settingsMenu": settingsMenu.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSaleBannerId": partnerSaleBannerId, "partnerUspSpecId": partnerUspSpecId, "partnerSettingsMenuId": partnerSettingsMenuId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var implementationId: String {
        get {
          return snapshot["implementationID"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "implementationID")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var tag: String? {
        get {
          return snapshot["tag"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "tag")
        }
      }

      public var clientIds: [String?]? {
        get {
          return snapshot["clientIds"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "clientIds")
        }
      }

      public var enablePsd2WebForm: Bool? {
        get {
          return snapshot["enablePSD2WebForm"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePSD2WebForm")
        }
      }

      public var enablePrePaidExtras: Bool? {
        get {
          return snapshot["enablePrePaidExtras"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enablePrePaidExtras")
        }
      }

      public var enableZeroExcess: Bool? {
        get {
          return snapshot["enableZeroExcess"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcess")
        }
      }

      public var enableZeroExcessUpSell: Bool? {
        get {
          return snapshot["enableZeroExcessUpSell"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableZeroExcessUpSell")
        }
      }

      public var enableQuickFilters: Bool? {
        get {
          return snapshot["enableQuickFilters"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableQuickFilters")
        }
      }

      public var enableRatings: Bool? {
        get {
          return snapshot["enableRatings"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableRatings")
        }
      }

      public var loyaltyRegex: String? {
        get {
          return snapshot["loyaltyRegex"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyRegex")
        }
      }

      public var enableCovidInsuranceMessage: Bool? {
        get {
          return snapshot["enableCovidInsuranceMessage"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableCovidInsuranceMessage")
        }
      }

      public var imageBaseUrl: String? {
        get {
          return snapshot["imageBaseURL"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "imageBaseURL")
        }
      }

      public var landingPageIcons: [String?]? {
        get {
          return snapshot["landingPageIcons"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIcons")
        }
      }

      public var landingPageIconsDark: [String?]? {
        get {
          return snapshot["landingPageIconsDark"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "landingPageIconsDark")
        }
      }

      public var enableTracking: Bool? {
        get {
          return snapshot["enableTracking"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableTracking")
        }
      }

      public var loyaltyProgramId: String? {
        get {
          return snapshot["loyaltyProgramId"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "loyaltyProgramId")
        }
      }

      public var ratingType: String? {
        get {
          return snapshot["ratingType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ratingType")
        }
      }

      public var enableLoyaltyRead: Bool? {
        get {
          return snapshot["enableLoyaltyRead"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableLoyaltyRead")
        }
      }

      public var forceCalendarFirstDayOfWeek: Int? {
        get {
          return snapshot["forceCalendarFirstDayOfWeek"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "forceCalendarFirstDayOfWeek")
        }
      }

      public var enableGooglePay: Bool? {
        get {
          return snapshot["enableGooglePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableGooglePay")
        }
      }

      public var enableApplePay: Bool? {
        get {
          return snapshot["enableApplePay"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "enableApplePay")
        }
      }

      public var chipDiscountMechanicType: String? {
        get {
          return snapshot["chipDiscountMechanicType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "chipDiscountMechanicType")
        }
      }

      public var saleBanner: SaleBanner? {
        get {
          return (snapshot["saleBanner"] as? Snapshot).flatMap { SaleBanner(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "saleBanner")
        }
      }

      public var supplierBenefitCodes: SupplierBenefitCode? {
        get {
          return (snapshot["supplierBenefitCodes"] as? Snapshot).flatMap { SupplierBenefitCode(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "supplierBenefitCodes")
        }
      }

      public var uspSpec: UspSpec? {
        get {
          return (snapshot["uspSpec"] as? Snapshot).flatMap { UspSpec(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "uspSpec")
        }
      }

      public var settingsMenu: SettingsMenu? {
        get {
          return (snapshot["settingsMenu"] as? Snapshot).flatMap { SettingsMenu(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "settingsMenu")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSaleBannerId: GraphQLID? {
        get {
          return snapshot["partnerSaleBannerId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSaleBannerId")
        }
      }

      public var partnerUspSpecId: GraphQLID? {
        get {
          return snapshot["partnerUspSpecId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerUspSpecId")
        }
      }

      public var partnerSettingsMenuId: GraphQLID? {
        get {
          return snapshot["partnerSettingsMenuId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSettingsMenuId")
        }
      }

      public struct SaleBanner: GraphQLSelectionSet {
        public static let possibleTypes = ["SaleBanner"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SupplierBenefitCode: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelSupplierBenefitCodeConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
          GraphQLField("nextToken", type: .scalar(String.self)),
          GraphQLField("startedAt", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(items: [Item?], nextToken: String? = nil, startedAt: Int? = nil) {
          self.init(snapshot: ["__typename": "ModelSupplierBenefitCodeConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken, "startedAt": startedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var items: [Item?] {
          get {
            return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }

        public var startedAt: Int? {
          get {
            return snapshot["startedAt"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["SupplierBenefitCode"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("type", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
            GraphQLField("_deleted", type: .scalar(Bool.self)),
            GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
            GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
            self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var type: String {
            get {
              return snapshot["type"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "type")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var updatedAt: String {
            get {
              return snapshot["updatedAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "updatedAt")
            }
          }

          public var version: Int {
            get {
              return snapshot["_version"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_version")
            }
          }

          public var deleted: Bool? {
            get {
              return snapshot["_deleted"] as? Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "_deleted")
            }
          }

          public var lastChangedAt: Int {
            get {
              return snapshot["_lastChangedAt"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "_lastChangedAt")
            }
          }

          public var partnerSupplierBenefitCodesId: GraphQLID? {
            get {
              return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
            }
          }
        }
      }

      public struct UspSpec: GraphQLSelectionSet {
        public static let possibleTypes = ["USPSpec"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }

      public struct SettingsMenu: GraphQLSelectionSet {
        public static let possibleTypes = ["SettingsMenu"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
          self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var type: String {
          get {
            return snapshot["type"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "type")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateSaleBannerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateSaleBanner($filter: ModelSubscriptionSaleBannerFilterInput) {\n  onCreateSaleBanner(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSaleBannerFilterInput?

  public init(filter: ModelSubscriptionSaleBannerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateSaleBanner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateSaleBanner: OnCreateSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateSaleBanner": onCreateSaleBanner.flatMap { $0.snapshot }])
    }

    public var onCreateSaleBanner: OnCreateSaleBanner? {
      get {
        return (snapshot["onCreateSaleBanner"] as? Snapshot).flatMap { OnCreateSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateSaleBanner")
      }
    }

    public struct OnCreateSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateSaleBannerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateSaleBanner($filter: ModelSubscriptionSaleBannerFilterInput) {\n  onUpdateSaleBanner(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSaleBannerFilterInput?

  public init(filter: ModelSubscriptionSaleBannerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateSaleBanner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateSaleBanner: OnUpdateSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateSaleBanner": onUpdateSaleBanner.flatMap { $0.snapshot }])
    }

    public var onUpdateSaleBanner: OnUpdateSaleBanner? {
      get {
        return (snapshot["onUpdateSaleBanner"] as? Snapshot).flatMap { OnUpdateSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateSaleBanner")
      }
    }

    public struct OnUpdateSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteSaleBannerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteSaleBanner($filter: ModelSubscriptionSaleBannerFilterInput) {\n  onDeleteSaleBanner(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSaleBannerFilterInput?

  public init(filter: ModelSubscriptionSaleBannerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteSaleBanner", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteSaleBanner.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteSaleBanner: OnDeleteSaleBanner? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteSaleBanner": onDeleteSaleBanner.flatMap { $0.snapshot }])
    }

    public var onDeleteSaleBanner: OnDeleteSaleBanner? {
      get {
        return (snapshot["onDeleteSaleBanner"] as? Snapshot).flatMap { OnDeleteSaleBanner(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteSaleBanner")
      }
    }

    public struct OnDeleteSaleBanner: GraphQLSelectionSet {
      public static let possibleTypes = ["SaleBanner"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SaleBanner", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateSupplierBenefitCodeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateSupplierBenefitCode($filter: ModelSubscriptionSupplierBenefitCodeFilterInput) {\n  onCreateSupplierBenefitCode(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var filter: ModelSubscriptionSupplierBenefitCodeFilterInput?

  public init(filter: ModelSubscriptionSupplierBenefitCodeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateSupplierBenefitCode", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateSupplierBenefitCode: OnCreateSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateSupplierBenefitCode": onCreateSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var onCreateSupplierBenefitCode: OnCreateSupplierBenefitCode? {
      get {
        return (snapshot["onCreateSupplierBenefitCode"] as? Snapshot).flatMap { OnCreateSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateSupplierBenefitCode")
      }
    }

    public struct OnCreateSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class OnUpdateSupplierBenefitCodeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateSupplierBenefitCode($filter: ModelSubscriptionSupplierBenefitCodeFilterInput) {\n  onUpdateSupplierBenefitCode(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var filter: ModelSubscriptionSupplierBenefitCodeFilterInput?

  public init(filter: ModelSubscriptionSupplierBenefitCodeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateSupplierBenefitCode", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateSupplierBenefitCode: OnUpdateSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateSupplierBenefitCode": onUpdateSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var onUpdateSupplierBenefitCode: OnUpdateSupplierBenefitCode? {
      get {
        return (snapshot["onUpdateSupplierBenefitCode"] as? Snapshot).flatMap { OnUpdateSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateSupplierBenefitCode")
      }
    }

    public struct OnUpdateSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class OnDeleteSupplierBenefitCodeSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteSupplierBenefitCode($filter: ModelSubscriptionSupplierBenefitCodeFilterInput) {\n  onDeleteSupplierBenefitCode(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n    partnerSupplierBenefitCodesId\n  }\n}"

  public var filter: ModelSubscriptionSupplierBenefitCodeFilterInput?

  public init(filter: ModelSubscriptionSupplierBenefitCodeFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteSupplierBenefitCode", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteSupplierBenefitCode.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteSupplierBenefitCode: OnDeleteSupplierBenefitCode? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteSupplierBenefitCode": onDeleteSupplierBenefitCode.flatMap { $0.snapshot }])
    }

    public var onDeleteSupplierBenefitCode: OnDeleteSupplierBenefitCode? {
      get {
        return (snapshot["onDeleteSupplierBenefitCode"] as? Snapshot).flatMap { OnDeleteSupplierBenefitCode(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteSupplierBenefitCode")
      }
    }

    public struct OnDeleteSupplierBenefitCode: GraphQLSelectionSet {
      public static let possibleTypes = ["SupplierBenefitCode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("partnerSupplierBenefitCodesId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int, partnerSupplierBenefitCodesId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "SupplierBenefitCode", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "partnerSupplierBenefitCodesId": partnerSupplierBenefitCodesId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var partnerSupplierBenefitCodesId: GraphQLID? {
        get {
          return snapshot["partnerSupplierBenefitCodesId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "partnerSupplierBenefitCodesId")
        }
      }
    }
  }
}

public final class OnCreateUspSpecSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateUSPSpec($filter: ModelSubscriptionUSPSpecFilterInput) {\n  onCreateUSPSpec(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionUSPSpecFilterInput?

  public init(filter: ModelSubscriptionUSPSpecFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateUSPSpec", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateUspSpec: OnCreateUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateUSPSpec": onCreateUspSpec.flatMap { $0.snapshot }])
    }

    public var onCreateUspSpec: OnCreateUspSpec? {
      get {
        return (snapshot["onCreateUSPSpec"] as? Snapshot).flatMap { OnCreateUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateUSPSpec")
      }
    }

    public struct OnCreateUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateUspSpecSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateUSPSpec($filter: ModelSubscriptionUSPSpecFilterInput) {\n  onUpdateUSPSpec(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionUSPSpecFilterInput?

  public init(filter: ModelSubscriptionUSPSpecFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateUSPSpec", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateUspSpec: OnUpdateUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateUSPSpec": onUpdateUspSpec.flatMap { $0.snapshot }])
    }

    public var onUpdateUspSpec: OnUpdateUspSpec? {
      get {
        return (snapshot["onUpdateUSPSpec"] as? Snapshot).flatMap { OnUpdateUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateUSPSpec")
      }
    }

    public struct OnUpdateUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteUspSpecSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteUSPSpec($filter: ModelSubscriptionUSPSpecFilterInput) {\n  onDeleteUSPSpec(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionUSPSpecFilterInput?

  public init(filter: ModelSubscriptionUSPSpecFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteUSPSpec", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteUspSpec.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteUspSpec: OnDeleteUspSpec? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteUSPSpec": onDeleteUspSpec.flatMap { $0.snapshot }])
    }

    public var onDeleteUspSpec: OnDeleteUspSpec? {
      get {
        return (snapshot["onDeleteUSPSpec"] as? Snapshot).flatMap { OnDeleteUspSpec(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteUSPSpec")
      }
    }

    public struct OnDeleteUspSpec: GraphQLSelectionSet {
      public static let possibleTypes = ["USPSpec"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "USPSpec", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnCreateSettingsMenuSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateSettingsMenu($filter: ModelSubscriptionSettingsMenuFilterInput) {\n  onCreateSettingsMenu(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSettingsMenuFilterInput?

  public init(filter: ModelSubscriptionSettingsMenuFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateSettingsMenu", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateSettingsMenu: OnCreateSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateSettingsMenu": onCreateSettingsMenu.flatMap { $0.snapshot }])
    }

    public var onCreateSettingsMenu: OnCreateSettingsMenu? {
      get {
        return (snapshot["onCreateSettingsMenu"] as? Snapshot).flatMap { OnCreateSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateSettingsMenu")
      }
    }

    public struct OnCreateSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnUpdateSettingsMenuSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateSettingsMenu($filter: ModelSubscriptionSettingsMenuFilterInput) {\n  onUpdateSettingsMenu(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSettingsMenuFilterInput?

  public init(filter: ModelSubscriptionSettingsMenuFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateSettingsMenu", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateSettingsMenu: OnUpdateSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateSettingsMenu": onUpdateSettingsMenu.flatMap { $0.snapshot }])
    }

    public var onUpdateSettingsMenu: OnUpdateSettingsMenu? {
      get {
        return (snapshot["onUpdateSettingsMenu"] as? Snapshot).flatMap { OnUpdateSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateSettingsMenu")
      }
    }

    public struct OnUpdateSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}

public final class OnDeleteSettingsMenuSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteSettingsMenu($filter: ModelSubscriptionSettingsMenuFilterInput) {\n  onDeleteSettingsMenu(filter: $filter) {\n    __typename\n    id\n    type\n    createdAt\n    updatedAt\n    _version\n    _deleted\n    _lastChangedAt\n  }\n}"

  public var filter: ModelSubscriptionSettingsMenuFilterInput?

  public init(filter: ModelSubscriptionSettingsMenuFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteSettingsMenu", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteSettingsMenu.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteSettingsMenu: OnDeleteSettingsMenu? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteSettingsMenu": onDeleteSettingsMenu.flatMap { $0.snapshot }])
    }

    public var onDeleteSettingsMenu: OnDeleteSettingsMenu? {
      get {
        return (snapshot["onDeleteSettingsMenu"] as? Snapshot).flatMap { OnDeleteSettingsMenu(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteSettingsMenu")
      }
    }

    public struct OnDeleteSettingsMenu: GraphQLSelectionSet {
      public static let possibleTypes = ["SettingsMenu"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, type: String, createdAt: String, updatedAt: String, version: Int, deleted: Bool? = nil, lastChangedAt: Int) {
        self.init(snapshot: ["__typename": "SettingsMenu", "id": id, "type": type, "createdAt": createdAt, "updatedAt": updatedAt, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var type: String {
        get {
          return snapshot["type"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "type")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }
    }
  }
}