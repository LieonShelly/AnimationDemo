//
//  IFLightModel.swift
//  AnimationDemo
//
//  Created by lieon on 2021/2/3.
//  Copyright © 2021 lieon. All rights reserved.
//

import Foundation

enum IFLightMenuSectionType {
    case origin([IFLightMennuOriginCellData])
    case custom([IFLightMennuOriginCellData])
    case recommend([MaterialItem])
    
    var sections: Int {
        switch self {
        case .origin(let lists):
            return lists.count
        case .custom(let lists):
            return lists.count
        case .recommend(let lists):
            return lists.count
        }
    }
}

struct IFLightMennuRecommendCellData {
    var iconURL: String?
    var title: String
}

struct IFLightMennuOriginCellData {
    var icon: UIImage
    var title: String
}



struct MaterialResponseTest: Codable {
    var status: String?
    var message: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case key
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decode(String.self, forKey: .status)
        message = try? container.decode(String.self, forKey: .message)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct MaterialResponse<T: Codable>: Codable {
    var data: T?
    var status: String?
    var message: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decode(String.self, forKey: .status)
        message = try? container.decode(String.self, forKey: .message)
        data = try? container.decode(T.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct Material: Codable {
    var items: [MaterialItem]
    var categories: [MaterialCategory]
    var packages: [MaterialPackage]
}

enum MaterialItemStauts {
    case unDownload
    case download
}

class MaterialItem: Codable {
    var itemID: String?
    var itemIcon: String?
    var itemName: String?
    var itemZipLink: String?
    var isLocal: Bool = false
    var remendParam: FX3DLightRecommendParam?
    
    private enum CodingKeys: String, CodingKey {
        case itemID
        case itemIcon
        case itemName
        case itemZipLink
    }
    
    required  init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemID = try? container.decode(String.self, forKey: .itemID)
        itemIcon = try? container.decode(String.self, forKey: .itemIcon)
        itemName = try? container.decode(String.self, forKey: .itemName)
        itemZipLink = try? container.decode(String.self, forKey: .itemZipLink)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct MaterialCategory: Codable {
    var categoryID: String?
    var categoryName: String?
    var categoryIcon: String?
    var packages: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case categoryID
        case categoryName
        case categoryIcon
        case packages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryID = try? container.decode(String.self, forKey: .categoryID)
        categoryName = try? container.decode(String.self, forKey: .categoryName)
        categoryIcon = try? container.decode(String.self, forKey: .categoryIcon)
        packages = try? container.decode([String].self, forKey: .packages)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

struct MaterialPackage: Codable {
    var packageID: String?
    var packageName: String?
    var packageIcon: String?
    var packageColor: String?
    var packageZipLink: String?
    var keywords: String?
    var items: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case packageID
        case packageName
        case packageIcon
        case packageColor
        case packageZipLink
        case keywords
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        packageID = try? container.decode(String.self, forKey: .packageID)
        packageName = try? container.decode(String.self, forKey: .packageName)
        packageIcon = try? container.decode(String.self, forKey: .packageIcon)
        
        packageColor = try? container.decode(String.self, forKey: .packageColor)
        packageZipLink = try? container.decode(String.self, forKey: .packageZipLink)
        keywords = try? container.decode(String.self, forKey: .keywords)
        items = try? container.decode([String].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}


enum FXConfigFunctionType: Int {
    case threedlight_basic = 2003
    case threedlight_facelight = 2002
    case threedlight_shapelight = 2005
    case threedlight_doublecolor = 2004
}

/// 3d打光的预设参数
class FX3DLightRecommendParam: Decodable, Encodable, NSCopying {
    var fType: Int = FXConfigFunctionType.threedlight_basic.rawValue
    var funcType: FXConfigFunctionType {
        set {
            fType = newValue.rawValue
        }
        get {
            return FXConfigFunctionType(rawValue: fType) ?? .threedlight_basic
        }
    }
    var belend: FX3DBlendMode?
    var lightSource: [FX3DLightSource] = []
    lazy var mask: FX3DLightMask = FX3DLightMask()
    fileprivate var _curveStr: String?
    var curveStr: String {
        set {
            if funcType != .threedlight_shapelight {
                _curveStr = newValue
            }
        }
        get {
            if _curveStr == nil {
                if funcType == .threedlight_basic {
                    _curveStr = "0 0 255 255"
                } else if funcType == .threedlight_facelight {
                    _curveStr = "110 110 255 255"
                }  else {
                    _curveStr = "0 0 255 255"
                }
            }
            if funcType == .threedlight_shapelight, let blendMode = belend?.belendMode {
                switch blendMode {
                case .shadow:
                    _curveStr = "0 255 255 0"
                case .soft:
                    _curveStr = "0 0 255 255"
                case .hardLight:
                    _curveStr = "0 0 255 255"
                default:
                    break
                }
            }
            return _curveStr!
        }
    }
    var curveSliderValue: CGFloat {
        let colors = curveStr.components(separatedBy: " ")
        guard colors.count > 2 else {
            return 0
        }
        let secondColor = colors[1] as String
        let num = Int(secondColor)
        if let tmpNum = num {
            switch funcType {
            case .threedlight_facelight:
                return FXMapTool.mapRevertValue(CGFloat(tmpNum), mapMaxV: 100, mapMinV: 0, uiMaxV: 127, uiMinV: 100)
            case .threedlight_basic:
                return FXMapTool.mapRevertValue(CGFloat(tmpNum), mapMaxV: 100, mapMinV: 0, uiMaxV: 127, uiMinV: 0)
            case .threedlight_doublecolor:
                return FXMapTool.mapRevertValue(CGFloat(tmpNum), mapMaxV: 100, mapMinV: 0, uiMaxV: 127, uiMinV: 0)
            default:
                break
            }
        }
        return 0
    }
    var spacular: FX3DLightSpacular?
    var name: String {
        switch funcType {
        case .threedlight_basic:
            return "氛围光"
        case .threedlight_facelight:
            return "面部光"
        case .threedlight_shapelight:
            return "形状光"
        case .threedlight_doublecolor:
            return "双色光"
        }
    }
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case belend = "belend"
        case lightSource = "light_source"
        case mask = "mask"
        case curveStr = "curve_str"
        case spacular = "spacular"
    }
    var lightIndex: Int = 0
    var currentLightSource: FX3DLightSource? {
        if lightIndex >= 0, lightIndex < lightSource.count {
            return lightSource[lightIndex]
        }
        if lightIndex == lightSource.count {
            let source = FX3DLightSource()
            lightSource.append(source)
            return source
        }
        return nil
    }
    var currentColor: UIColor {
        set {
            currentLightSource?.color = newValue
        }
        get {
            return currentLightSource?.color ?? .white
        }
    }
    var colorUpdateSource: FX3dLightColorSource {
        set {
            currentLightSource?.colorUpdateSource = newValue
        }
        get {
            return currentLightSource?.colorUpdateSource ?? .colorSlider
        }
    }
    var originalLightSources: [FX3DLightSource] = []
    var locationUpdated: Bool {
        return currentLightSource?.locationUpdated ?? false
    }
    var colorUpdated: Bool {
        return currentLightSource?.colorUpdated ?? false
    }
    var firstColor: UIColor? {
        if lightIndex < lightSource.count {
            return lightSource[lightIndex].color
        }
        return nil
    }
    var lastColor: UIColor? {
        if lightIndex < lightSource.count {
            if lightIndex == 0 {
                return lightSource.last?.color
            } else if lightIndex == 1 {
                return lightSource.first?.color
            }
        }
        return nil
    }
    
    required init() {
        self.belend = FX3DBlendMode()
        self.mask = FX3DLightMask()
        self.spacular = FX3DLightSpacular()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Int.self, forKey: .type) { fType = value }
        if let value = try? container.decode(FX3DBlendMode.self, forKey: .belend) { belend = value }
        if let value = try? container.decode([FX3DLightSource].self, forKey: .lightSource) {
            lightSource = value
            originalLightSources = value.map({ $0.copy() as! FX3DLightSource })
        }
        if let value = try? container.decode(FX3DLightMask.self, forKey: .mask) {
            mask = value
        }
        if let value = try? container.decode(String.self, forKey: .curveStr) {
            if funcType == .threedlight_shapelight, let blendMode = belend?.belendMode {
                switch blendMode {
                case .shadow:
                    _curveStr = "0 255 255 0"
                case .soft:
                    _curveStr = "0 0 255 255"
                case .hardLight:
                    _curveStr = "0 0 255 255"
                default:
                    break
                }
            } else {
                _curveStr = value
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fType, forKey: .type)
        try container.encode(belend, forKey: .belend)
        try container.encode(lightSource, forKey: .lightSource)
        try container.encode(mask, forKey: .mask)
        try container.encode(curveStr, forKey: .curveStr)
    }
    
    func toJSON() -> [String: Any]? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            return json
        }
        return nil
    }
    
    func toString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            let jString = String.init(data: data, encoding: .utf8)
            return jString
        } catch {
            
        }
        return nil
    }
    
    func serializeToFile(_ path: String, name: String, resourcePath: String? = nil) -> Bool {
    
        return true
    }
    
    func update(_ param: FX3DLightRecommendParam) {
        fType = param.fType
        lightSource = param.lightSource.map({ $0.copy() as! FX3DLightSource })
        belend = param.belend?.copy() as? FX3DBlendMode
        if let mask = param.mask.copy() as? FX3DLightMask {
            self.mask = mask
        }
        curveStr = param.curveStr
        spacular = param.spacular?.copy() as? FX3DLightSpacular
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.fType = fType
        obj.lightSource = lightSource.map({ $0.copy() as! FX3DLightSource })
        obj.belend = belend?.copy() as? FX3DBlendMode
        if let mask = mask.copy() as? FX3DLightMask {
            obj.mask = mask
        }
        obj.curveStr = curveStr
        obj.spacular = spacular?.copy() as? FX3DLightSpacular
        return obj
    }
    
    func recoverData() {
        lightSource = originalLightSources.map({ $0.copy() as! FX3DLightSource })
    }
}

// 3d打光的混合模式 - 和下层对应
enum FX3dLightBlendMode: Int, Codable {
    case overlay = 12 // 叠加12 - 柔光
    case linearLight = 16 // 线性光16 -  聚光
    case normal = 0
    case shadow = 5 // 底层：线性加深5 - 上层：投影
    case hardLight = 10 //底层： 线性减淡(添加)10 - 上层：强光
    case soft = 14 //  底层：强光14 - 上层：柔光
//
//
//    static func generate(_ funcType: FXConfigFunctionType) -> FX3dLightBlendMode {
//        switch funcType {
//        case .threedlight_lightdegree_weak:
//            return .overlay
//        case .threedlight_lightdegree_strong:
//            return .linearLight
//        default:
//            return .normal
//        }
//    }
//    var maxOpacity: CGFloat {
//        switch self {
//        case .overlay:
//            return 1
//        case .linearLight:
//            return 0.5
//        default:
//            return 1
//        }
//    }
//    var minOpacity: CGFloat {
//        return 0
//    }
//
//    var logExtraInfo: String {
//        switch self {
//        case .overlay:
//            return "soft_light"
//        case .linearLight:
//            return "linear_light"
//        case .shadow:
//            return "dark_light"
//        case .soft:
//            return "soft_light"
//        case .hardLight:
//            return "glare_light"
//        default:
//            return "normal"
//        }
//    }
//
//    /// UI上对应的index
//    var index: Int {
//        switch self {
//        case .overlay,  .shadow:
//            return 0
//        case .linearLight, .hardLight:
//            return 1
//        case .soft:
//            return 2
//        default:
//            return 0
//        }
//    }
//
//    static func createFaceBasicBlendModeUIData() -> [FX3DLightTypeChooseView.UIEntity] {
//        return [FX3DLightTypeChooseView.UIEntity("柔光".localized_FX(), isSelected: false),
//                FX3DLightTypeChooseView.UIEntity("聚光".localized_FX(), isSelected: false)]
//    }
//
//    static func createDoubleColorBlendModeUIData() -> [FX3DLightTypeChooseView.UIEntity] {
//        var list = [FX3DLightTypeChooseView.UIEntity("柔光".localized_FX(), isSelected: false),
//                    FX3DLightTypeChooseView.UIEntity("聚光".localized_FX(), isSelected: false)]
//        if kIsDebug || kIsQARelease {
//            list.append(FX3DLightTypeChooseView.UIEntity("正常".localized_FX(), isSelected: false))
//        }
//        return list
//    }
//
//    static func createShapeBlendModeUIData() -> [FX3DLightTypeChooseView.UIEntity] {
//        var list = [FX3DLightTypeChooseView.UIEntity("投影".localized_FX(), isSelected: false),
//                    FX3DLightTypeChooseView.UIEntity("强光".localized_FX(), isSelected: false),
//                    FX3DLightTypeChooseView.UIEntity("柔光".localized_FX(), isSelected: false)]
//        if kIsDebug || kIsQARelease {
//            list.append(FX3DLightTypeChooseView.UIEntity("正常".localized_FX(), isSelected: false))
//        }
//        return list
//    }

}

class FX3DBlendMode: Codable, NSCopying {
    var opacity: CGFloat = 1
    var belendMode: FX3dLightBlendMode = .overlay
    var dimCount: CGFloat = 0
    required init() {}
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.opacity = opacity
        obj.belendMode = belendMode
        obj.dimCount = dimCount
        return obj
    }
}


/// 面部光的位置类型 FX3dFaceLightPositionType
enum FX3dLightFacePositionType: String, Codable {
    /// 光源的参考点在鼻尖
    case nose = "nose"
    /// 参考点在左上角
    case faceLeftTop = "faceLeftTop"
    
}

enum FX3dLightColorSource {
    case colorSlider
    case colorPannel
    
    var logInfo: String {
        switch self {
        case .colorSlider:
            return "1"
        case .colorPannel:
            return "2"
        }
    }
}

// 光源相关的参数
class FX3DLightSource: Codable, NSCopying {
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var positionZ: CGFloat = 0
    /// rgbd的归一化值
    var colorG: CGFloat = 0
    var colorB: CGFloat = 0
    var colorR: CGFloat = 0
    var circleCutOff: CGFloat = 200
    var circleOutCutOff: CGFloat = 300
    var colorProgress: CGFloat?
    fileprivate(set) var locationUpdated: Bool = false
    fileprivate(set) var colorUpdated: Bool = false
    var colorUpdateSource: FX3dLightColorSource = .colorSlider
    
    var position2D: CGPoint {
        set {
            positionX = newValue.x
            positionY = newValue.y
            locationUpdated = true
        }
        get {
            return CGPoint(x: positionX, y: positionY)
        }
    }
    
    var color: UIColor {
        set {
            let rgb = newValue.getColorRGB()
            colorR = rgb.red
            colorG = rgb.green
            colorB = rgb.blue
            colorUpdated = true
        }
        get {
            return UIColor(red: colorR, green: colorG, blue: colorB, alpha: 1)
        }
    }
    var positionType: FX3dLightFacePositionType = .faceLeftTop
    
    private enum CodingKeys: String, CodingKey {
        case positionX
        case positionY
        case positionZ
        case colorG
        case colorB
        case colorR
        case circleCutOff
        case circleOutCutOff
        case colorProgress
        case positionType
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(CGFloat.self, forKey: .positionX) { positionX = value }
        if let value = try? container.decode(CGFloat.self, forKey: .positionY) { positionY = value }
        if let value = try? container.decode(CGFloat.self, forKey: .positionZ) { positionZ = value }
        if let value = try? container.decode(CGFloat.self, forKey: .colorG) { colorG = value }
        if let value = try? container.decode(CGFloat.self, forKey: .colorR) { colorR = value }
        if let value = try? container.decode(CGFloat.self, forKey: .colorB) { colorB = value }
        if let value = try? container.decode(CGFloat.self, forKey: .circleCutOff) { circleCutOff = value }
        if let value = try? container.decode(CGFloat.self, forKey: .circleOutCutOff) { circleOutCutOff = value }
        if let value = try? container.decode(CGFloat.self, forKey: .colorProgress) { colorProgress = value }
        if let value = try? container.decode(FX3dLightFacePositionType.self, forKey: .positionType) {
            positionType = value
        } else {
            positionType = .faceLeftTop
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(positionX, forKey: .positionX)
        try? container.encode(positionY, forKey: .positionY)
        try? container.encode(positionZ, forKey: .positionZ)
        try? container.encode(colorG, forKey: .colorG)
        try? container.encode(colorR, forKey: .colorR)
        try? container.encode(colorB, forKey: .colorB)
        try? container.encode(circleCutOff, forKey: .circleCutOff)
        try? container.encode(circleOutCutOff, forKey: .circleOutCutOff)
        try? container.encode(positionType, forKey: .positionType)
        if colorProgress != nil { try? container.encode(colorProgress, forKey: .colorProgress) }
    }
    
    required init() {}
    
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.positionX = positionX
        obj.positionY = positionY
        obj.positionZ = positionZ
        obj.colorR = colorR
        obj.colorG = colorG
        obj.colorB = colorB
        obj.circleCutOff = circleCutOff
        obj.circleOutCutOff = circleOutCutOff
        obj.colorProgress = colorProgress
        obj.positionType = positionType
        return obj
    }
}

// 蒙版相关的参数
class FX3DLightMask: Codable, NSCopying {
    var shapeResult: Bool = false
    var shapePositionX: CGFloat = 0
    var shapePositionY: CGFloat = 0
    var shapePositionZ: CGFloat = 0
    var shapeNormalAngleX: CGFloat = 0
    var shapeNormalAngleY: CGFloat = 0
    var shapeNormalAngleZ: CGFloat = 0
    var fitFace: Bool = true
    var shapeSizeX: CGFloat = 0
    var shapeSizeY: CGFloat = 0
    var fullImg: Bool = false
    fileprivate(set) var locationUpdated: Bool = false
    var shapePostion2D: CGPoint {
        set {
            shapePositionX = newValue.x
            shapePositionY = newValue.y
            locationUpdated = true
        }
        get {
            return CGPoint(x: shapePositionX, y: shapePositionY)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case shapeResult
        case shapePositionX
        case shapePositionY
        case shapePositionZ
        case shapeNormalAngleX
        case shapeNormalAngleY
        case shapeNormalAngleZ
        case fitFace
        case shapeSizeX
        case shapeSizeY
        case fullImg
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Bool.self, forKey: .shapeResult) { shapeResult = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapePositionX) { shapePositionX = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapePositionY) { shapePositionY = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapePositionZ) { shapePositionZ = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapeNormalAngleX) { shapeNormalAngleX = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapeNormalAngleY) { shapeNormalAngleY = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapeNormalAngleZ) { shapeNormalAngleZ = value }
        if let value = try? container.decode(Bool.self, forKey: .fitFace) { fitFace = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapeSizeX) { shapeSizeX = value }
        if let value = try? container.decode(CGFloat.self, forKey: .shapeSizeY) { shapeSizeY = value }
        if let value = try? container.decode(Bool.self, forKey: .fullImg) { fullImg = value }
        locationUpdated = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(shapeResult, forKey: .shapeResult)
        try? container.encode(shapePositionX, forKey: .shapePositionX)
        try? container.encode(shapePositionY, forKey: .shapePositionY)
        try? container.encode(shapePositionZ, forKey: .shapePositionZ)
        try? container.encode(shapeNormalAngleX, forKey: .shapeNormalAngleX)
        try? container.encode(shapeNormalAngleY, forKey: .shapeNormalAngleY)
        try? container.encode(shapeNormalAngleZ, forKey: .shapeNormalAngleZ)
        try? container.encode(fitFace, forKey: .fitFace)
        try? container.encode(shapeSizeX, forKey: .shapeSizeX)
        try? container.encode(shapeSizeY, forKey: .shapeSizeY)
        try? container.encode(fullImg, forKey: .fullImg)
    }

    required init() {}
    
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.shapeResult = shapeResult
        obj.shapePositionX = shapePositionX
        obj.shapePositionY = shapePositionY
        obj.shapePositionZ = shapePositionZ
        obj.shapeNormalAngleX = shapeNormalAngleX
        obj.shapeNormalAngleY = shapeNormalAngleY
        obj.shapeNormalAngleZ = shapeNormalAngleZ
        obj.fitFace = fitFace
        obj.shapeSizeX = shapeSizeX
        obj.shapeSizeY = shapeSizeY
        obj.fullImg = fullImg
        return obj
    }
}

/// 材质相关的
class FX3DLightSpacular: Codable, NSCopying {
    var spacularX: CGFloat = 0.5
    var spacularY: CGFloat = 0.4
    var spacularZ: CGFloat = 0.4
    required init() {}
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.spacularX = spacularX
        obj.spacularY = spacularY
        obj.spacularZ = spacularZ
        return obj
    }
}

class FXMapTool {
    /// 最大值映射为最小值，最小值映射为最大值
    static func mapRevertValue(_ inputValue: CGFloat, mapMaxV: CGFloat, mapMinV: CGFloat, uiMaxV: CGFloat, uiMinV: CGFloat) -> CGFloat {
        let value = mapMaxV - ((mapMaxV - mapMinV) * (inputValue - uiMinV) / (uiMaxV - uiMinV))
        if value > mapMaxV {
            return mapMaxV
        } else {
            if value < mapMinV {
                return mapMinV
            }
            return value
        }
    }
    
    static  func mapValue(_ inputValue: CGFloat, mapMaxV: CGFloat, mapMinV: CGFloat, uiMaxV: CGFloat, uiMinV: CGFloat) -> CGFloat {
        var realV: CGFloat = ((mapMaxV - mapMinV) * (inputValue - uiMinV) / (uiMaxV - uiMinV)) + mapMinV
        if realV > mapMaxV {
            realV = mapMaxV
        } else if realV < mapMinV {
            realV = mapMinV
        }
        return realV
    }
}


