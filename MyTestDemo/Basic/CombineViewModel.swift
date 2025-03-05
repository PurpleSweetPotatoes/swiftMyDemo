//
//  StateViewModel.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2023/3/17.
//  Copyright © 2023 Garmin All rights reserved
//  

import Combine
import Foundation
// 声明了@dynamicMemberLookup后，即使属性没有定义，但是程序会在运行时动态的查找属性的值，调用subscript(dynamicMember member: String)方法来获取值
@dynamicMemberLookup
open class StateViewModel<State, Action>: ObservableObject {
    @Published open var state: State

    public init(initialState: State) {
        state = initialState
    }

    open func trigger(_ action: Action) {
        assert(false, "This method must be implemented in subclasses")
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }
}

/// Base class for ViewState view models used for UIKit features
//open class BindableStateViewModel<event, action> {
//    /// The view state or display event observable property. Define a feature specific enum
//    public let event: Dynamic<event>
//
//    /// The view model must be initialized with an initial state/event
//    public init(initialEvent: event) {
//        event = Dynamic(initialEvent, notifyOnMain: true)
//    }
//
//    /// Used by the view to trigger a view action
//    /// - Parameter action: the view action
//    open func trigger(_ action: action) {
//        assert(false, "This method must be implemented in subclasses")
//    }
//}


//
//  AppSecurityChecker.swift
//  ConnectMobile
//
//  Created by Bai, Payne on 2025/2/26.
//  Copyright © 2025 Garmin International, Inc. All rights reserved.
//

import Foundation
import MachO
import OSLog

public struct AppInfoData {
    let appName: String
    // It will check if the app bunlde ID matches the expected one when it is not nil.
    let bundleID: String?
    // It will check if the development team ID matches the expected one when it is not nil.
    let teamID: String?
    // It will check if the dynamic library matches the expected one when it is not nil.
    let whiteFrameworks: [String]?

    public init(appName: String,
                bundleID: String? = nil,
                teamID: String? = nil,
                whiteFrameworks: [String]?) {
        self.appName = appName
        self.bundleID = bundleID
        self.teamID = teamID
        self.whiteFrameworks = whiteFrameworks
    }
}

/// Used for app security checks. Checks are not performed in debug mode.
/// Items jailBroken and debugExecutable are default checks, while other checks will be determined based on the expectData configuration.
public class AppSecurityChecker {
    public enum SecurityAbnormalState: String, CustomStringConvertible {
        case jailBroken
        case debugExecutable
        case teamIDMismatch
        case bundleIDMismatch
        case insertLibrary

        public var description: String { rawValue }
    }

    private let expectData: AppInfoData
    private let logger = Logger(subsystem: "com.garmin.connect.mobile", category: "AppSecurityChecker")
    private var teamID: String?
    private var bundleID: String?

    public init(expectData: AppInfoData) {
        self.expectData = expectData
    }

    @discardableResult
    public func startCheck() -> [SecurityAbnormalState] {
        logger.info("start check security")
        guard !UIDevice.isDebugMode else {
            logger.info("skip checks in debug mode")
            return []
        }

        paraseEmbededData()

        var abnormalStates: [SecurityAbnormalState] = []
        if isJailbroken { abnormalStates.append(.jailBroken) }
        if isDebugExecutable { abnormalStates.append(.debugExecutable) }
        if !teamIDValid { abnormalStates.append(.teamIDMismatch) }
        if !bundleIDValid { abnormalStates.append(.bundleIDMismatch) }
        if isLibraryInjection { abnormalStates.append(.insertLibrary) }
        logger.info("security abnormal states: \(abnormalStates)")

        return abnormalStates
    }
}

private extension AppSecurityChecker {
    enum Constants {
        static let signatureFileName = "embedded"
        static let signatureFileType = "mobileprovision"
        static let insetLibrariesKey = "DYLD_INSERT_LIBRARIES"
        static let entitlementsKey = "Entitlements"
        static let appIdentifierKey = "application-identifier"
    }

    var isJailbroken: Bool {
        guard !UIDevice.isDebugMode else {
            return false
        }

        // The emulator contains two paths, "/bin/bash" and "/usr/sbin/sshd", so the emulator is not verified.
        guard !UIDevice.isSimulator else {
            return false
        }

        // Common paths for apps on jailbroken phones
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate",
            "/var/lib/apt",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]

        if paths.contains(where: { FileManager.default.fileExists(atPath: $0) }) {
            return true
        }

        do {
            // Check if it is possible to write to the system path.
            let path = "/private/jailbreak_test"
            try "test".write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    /// Selected debugger executable at scheme info will return true
    var isDebugExecutable: Bool {
        // Initialize all the fields so that,
        // if sysctl fails for some bizarre reason, we get a predictable result.
        var info = kinfo_proc()
        // Initialize mib, which tells sysctl the info we want,
        // in this case we're looking for info about a specific process ID.
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        // Call sysctl.
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        // We're being debugged if the P_TRACED flag is set.
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

    var isLibraryInjection: Bool {
        // Check if the white frameworks is nil
        guard let whiteFrameworks = expectData.whiteFrameworks else {
            return false
        }

        // Check if the inset library is enable
        guard getenv(Constants.insetLibrariesKey) == nil else {
            return true
        }

        // Check if the added libraries meet the expectations.
        var isInsertLibrary = false
        let count = _dyld_image_count()
        for i in 0 ..< count {
            guard let name = _dyld_get_image_name(i) else {
                continue
            }
            let libName = String(cString: name)
            if libName.contains("/\(expectData.appName).app/"),
               !libName.hasSuffix(".dylib"),
               !libName.hasSuffix(expectData.appName),
               !whiteFrameworks.contains(libName.lastPathComponentName) {
                logger.warning("found insert library: \(libName.lastPathComponentName)")
                isInsertLibrary = true
            }
        }
        return isInsertLibrary
    }

    var teamIDValid: Bool {
        guard let expectedTeamID = expectData.teamID,
              let teamID else {
            return true
        }

        if expectedTeamID == teamID {
            return true
        } else {
            logger.warning("teamID mismatch: current \(teamID) -- expected \(expectedTeamID)")
            return false
        }
    }

    var bundleIDValid: Bool {
        guard let expectedBundleID = expectData.bundleID,
              let bundleID else {
            return true
        }

        if bundleID == expectedBundleID {
            return true
        } else {
            logger.warning("bundleID mismatch: current \(bundleID) -- expected \(expectedBundleID)")
            return false
        }
    }

    func paraseEmbededData() {
        guard let path = Bundle.main.path(forResource: Constants.signatureFileName, ofType: Constants.signatureFileType) else {
            logger.info("didn't found embedded.mobileprovision file")
            return
        }
        // Apps downloaded from the App Store do not contain this file, but internal enterprise apps or apps on jailbroken devices may include this file.
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let binaryString = String(data: data, encoding: .isoLatin1) else {
            logger.error("load embedded.mobileprovision data failed")
            return
        }

        do {
            let pattern = "<plist.*?</plist>"
            let regex = try NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
            let results = regex.matches(in: binaryString, options: [], range: NSRange(location: 0, length: binaryString.count))

            guard let match = results.first else {
                logger.error("parase embedded.mobileprovision plist failed")
                return
            }

            let plistStr = binaryString[match.range.location...(match.range.location + match.range.length)]
            guard let data = plistStr.data(using: .utf8),
                  let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
                  let entitlements = plist[Constants.entitlementsKey] as? [String: Any],
                  let entitlementID = entitlements[Constants.appIdentifierKey] as? String else {
                logger.error("parase embedded.mobileprovision entitlementID failed")
                return
            }

            var identifierList = entitlementID.components(separatedBy: ".")
            teamID = identifierList.removeFirst()
            bundleID = identifierList.joined(separator: ".")
        } catch let error {
            logger.error("parase embedded.mobileprovision failed: \(error.localizedDescription)")
        }
    }
}

private extension String {
    var lastPathComponentName: String {
        guard let last = split(separator: "/").last,
              let name = last.split(separator: ".").first else {
            return self
        }
        return String(name)
    }

    subscript(range: ClosedRange<Int>) -> String {
        if range.lowerBound < 0 || range.upperBound > count {
            return self
        }
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
}

private extension UIDevice {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    static var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
