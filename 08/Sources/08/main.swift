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

func vmFiles(dirPath: String) -> [String] {
    let fileManager = FileManager.default
    do {
        let list = try fileManager.contentsOfDirectory(atPath: dirPath)
        let vmList = list.filter {
            let name = $0 as NSString
            return name.pathExtension == "vm"
        }
        let vmFilePaths: [String] = vmList.map { vmFileName in 
            let dirPath = (dirPath as NSString).deletingPathExtension
            return "\(dirPath)/\(vmFileName)"
        }
        return vmFilePaths
    } catch {
        fatalError("directory get errro.")
    }
    return []
}

func main(path: String) {
    let pathPrefix = (path as NSString).deletingPathExtension
    let writeFileName: String

    var vmPaths = [String]()
    if isDirectory(path: path) {
        vmPaths.append(contentsOf: vmFiles(dirPath: path))
        let dirname = (path as NSString).lastPathComponent
        writeFileName = "\(pathPrefix)/\(dirname).asm" 
    } else {
        vmPaths = [path]
        writeFileName = "\(pathPrefix).asm"
    }

    let parser = Parser(paths: vmPaths)
    let codeWriter = CodeWriter()
    codeWriter.setFileName(fileName: writeFileName)

    do {
        while parser.hasMoreCommands() {
            parser.advance()
            let commandType = parser.commandType()
            switch commandType {
            case .C_ARITHMETRIC:
                print("算術演算: \(parser.label())")
                codeWriter.writeArithmetic(command: parser.label())
            case .C_PUSH:
                print("プッシュ")
                print(" - " + parser.arg1())
                print(" - " + String(parser.arg2()))

                codeWriter.writePushPop(command: .push, segment: parser.arg1(), index: parser.arg2())
            case .C_POP:
                print("ポップ")
                print(" - " + parser.arg1())
                print(" - " + String(parser.arg2()))
                codeWriter.writePushPop(command: .pop, segment: parser.arg1(), index: parser.arg2())
            case .C_LABEL:
                print("ラベル")
                print(" - " + parser.arg1())
                codeWriter.writeLabel(label: parser.arg1())
            case .C_GOTO:
                print("ゴー")
                print(" - " + parser.arg1())
                codeWriter.writeGoto(label: parser.arg1())
            case .C_IF:
                print("条件分岐")
                print(" - " + parser.arg1())
                codeWriter.writeIf(label: parser.arg1())
            case .C_FUNCTION:
                print("関数")
                print(" - " + parser.arg1())
                print(" - " + String(parser.arg2()))
                codeWriter.writeFunction(functionName: parser.arg1(), numLocals: parser.arg2())
            case .C_RETURN:
                print("リターン")
                codeWriter.writeReturn()
            case .C_CALL:
                print("コール")
                print(" - " + parser.arg1())
                print(" - " + String(parser.arg2()))
                codeWriter.writeCall(functionName: parser.arg1(), numArgs: parser.arg2())
            }
        }
    }
}

if CommandLine.arguments.count == 2  {
    main(path: CommandLine.arguments[1])
}
