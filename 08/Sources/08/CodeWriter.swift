import Foundation

class CodeWriter {
    var writeURL: URL?
    var ifCommandIndex = 1
    var vmFileName: String = ""

    public init() {

    }

    func setFileName(fileName: String) {
        writeURL = URL(fileURLWithPath: fileName)
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        removeFile(fileURL: writeURL)
        let vmFilePath = (writeURL.absoluteString as NSString).deletingPathExtension
        vmFileName = (vmFilePath as NSString).lastPathComponent
    }

    func writeArithmetic(command: String) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        guard let arithmeticType = CommandArithmeticType(rawValue: command) else { fatalError("arithmetic type error.") }
        switch arithmeticType {
            case .add:
                let addCommand = AddCommand()
                let asm = addCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
            case .sub:
                let subCommand = SubCommand()
                let asm = subCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
            case .neg:
                let negCommand = NegCommand()
                let asm = negCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
            case .eq:
                let eqCommand = EqCommand(index: ifCommandIndex)
                let asm = eqCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
                ifCommandIndex += 1
            case .gt:
                let gtCommand = GtCommand(index: ifCommandIndex)
                let asm = gtCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
                ifCommandIndex += 1
            case .lt:
                let ltCommand = LtCommand(index: ifCommandIndex)
                let asm = ltCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
                ifCommandIndex += 1
            case .and:
                let andCommand = AndCommand()
                let asm = andCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
            case .or:
                let orCommand = OrCommand()
                let asm = orCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
            case .not:
                let notCommand = NotCommand()
                let asm = notCommand.convert()
                write(url: writeURL, text: "\(asm)\n")
        }
    }

    func writePushPop(command: CommandPushPopType, segment: String, index: Int) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        switch command {
            case .push:
                let pushCommand = PushCommand(segment: segment, index: index, vmFileName: vmFileName)
                write(url: writeURL, text: "\(pushCommand.convert())\n")
            case .pop:
                let popCommand = PopCommand(segment: segment, index: index, vmFileName: vmFileName)
                write(url: writeURL, text: "\(popCommand.convert())\n")
        }
    }

    // VMの初期化
    func writeInit() {

    }

    // labelコマンド
    func writeLabel(label: String) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let labelCommand = LabelCommand(label: label)
        let asm = labelCommand.convert()
        write(url: writeURL, text: "\(asm)\n")
    }

    // gotoコマンド
    func writeGoto(label: String) {

    }

    // if-gotoコマンド
    func writeIf(label: String) {

    }

    // callコマンド
    func writeCall(functionName: String, numArgs: Int) {

    }

    // returnコマンド
    func writeReturn() {

    }

    // functionコマンド
    func writeFunction(functionName: String, numLocals: Int) {

    }



    func close() {

    }

    private func write(url: URL, text: String) -> Bool {
        guard let stream = OutputStream(url: url, append: true) else {
            return false
        }
        stream.open()
        
        defer {
            stream.close()
        }
        
        guard let data = text.data(using: .utf8) else { return false }
        
        let result = data.withUnsafeBytes {
            stream.write($0, maxLength: data.count)
        }
        return (result > 0)
    }

    private func removeFile(fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("delete file error")
        }
    }
}