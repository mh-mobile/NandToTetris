import Foundation

func isDirectory(path: String) -> Bool {
    let fileManager = FileManager.default
    var isDir:ObjCBool = false
    if fileManager.fileExists(atPath: path, isDirectory: &isDir)  {
        if isDir.boolValue {
            return true
        }
    }

    return false
}

func jackFiles(dirPath: String) -> [String] {
    let fileManager = FileManager.default
    do {
        let list = try fileManager.contentsOfDirectory(atPath: dirPath)
        let jackList = list.filter {
            let name = $0 as NSString
            return name.pathExtension == "jack"
        }
        let jackFilePaths: [String] = jackList.map { jackFileName in 
            let dirPath = (dirPath as NSString).deletingPathExtension
            return "\(dirPath)/\(jackFileName)"
        }
        return jackFilePaths
    } catch {
        fatalError("directory get errro.")
    }
    return []
}

func main(path: String) {
    let pathPrefix = (path as NSString).deletingPathExtension
    let writeFileName: String

    var jackPaths = [String]()
    if isDirectory(path: path) {
        jackPaths.append(contentsOf: jackFiles(dirPath: path))
        let dirname = (path as NSString).lastPathComponent
        writeFileName = "\(pathPrefix)/\(dirname).xml" 
    } else {
        jackPaths = [path]
        writeFileName = "\(pathPrefix).xml"
    }

    print("jackPaths: \(jackPaths)")
    let analyzer = JackAnalyzer(sources: jackPaths)
    analyzer.analyze()
}

if CommandLine.arguments.count == 2  {
    main(path: CommandLine.arguments[1])
}