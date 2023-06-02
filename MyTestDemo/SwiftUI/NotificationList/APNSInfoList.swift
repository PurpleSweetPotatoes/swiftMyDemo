import Foundation

protocol APNSDataSource {
    var json: String { get }
    var title: String { get }
    var time: Date { get }
    var apnsKey: String { get }
}

struct APNSInfo: APNSDataSource, Codable {
    var json: String
    var title: String
    var time: Date
    var apnsKey: String
}

struct APNSInfoHelper {
    private static let infoPath = "\(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])/GC/APNSInfo/apnsList.json"

    static func apnsList() -> [APNSInfo] {
        guard FileManager.default.fileExists(atPath: infoPath),
              let jsonStr = try? String(contentsOfFile: infoPath, encoding: .utf8),
              let data = jsonStr.data(using: .utf8),
              let list = try? JSONDecoder().decode([APNSInfo].self, from: data) else {
            return []
        }
        return list
    }

    static func add(_ jsonDic: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted),
              let json = String(data: data, encoding: .utf8) else {
            return
        }
        let info = APNSInfo(json: json, title: "AAA", time: Date(), apnsKey: "cc")
        var apnsList = apnsList()
        if apnsList.count == 10 {
            apnsList.removeFirst()
        }
        apnsList.append(info)
        saveLocal(apnsList)
    }

    static func removeAll() {
        saveLocal([])
    }

    static func saveLocal(_ apnsList: [APNSInfo]) {
        guard let data = try? JSONEncoder().encode(apnsList),
              let jsonString = String(data: data, encoding: .utf8) else {
            return
        }
        if !FileManager.default.fileExists(atPath: infoPath) {
            FileManager.default.createFile(atPath: infoPath, contents: nil)
        }
        try? jsonString.write(toFile: infoPath, atomically: true, encoding: .utf8)
    }
}
