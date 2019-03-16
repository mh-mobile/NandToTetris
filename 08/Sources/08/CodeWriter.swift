import Foundation

class CodeWriter {
    var writeURL: URL?
    var ifCommandIndex = 1
    var vmFileName: String = ""
    var asmFileName: String = ""

    public init(fileName: String) {
        writeURL = URL(fileURLWithPath: fileName)
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        removeFile(fileURL: writeURL)
        let asmFilePath = (writeURL.absoluteString as NSString).deletingPathExtension
        asmFileName = (asmFilePath as NSString).lastPathComponent
    }

    func setFileName(fileName: String) {
        vmFileName = fileName
    }

    func writeArithmetic(command: String, functionName: String?) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        guard let arithmeticType = CommandArithmeticType(rawValue: command) else { fatalError("arithmetic type error.") }
        switch arithmeticType {
            case .add:
                let addCommand = AddCommand()
                let asm = addCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
            case .sub:
                let subCommand = SubCommand()
                let asm = subCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
            case .neg:
                let negCommand = NegCommand()
                let asm = negCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
            case .eq:
                let eqCommand = EqCommand(index: ifCommandIndex, functionName: functionName)
                let asm = eqCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
                ifCommandIndex += 1
            case .gt:
                let gtCommand = GtCommand(index: ifCommandIndex, functionName: functionName)
                let asm = gtCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
                ifCommandIndex += 1
            case .lt:
                let ltCommand = LtCommand(index: ifCommandIndex, functionName: functionName)
                let asm = ltCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
                ifCommandIndex += 1
            case .and:
                let andCommand = AndCommand()
                let asm = andCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
            case .or:
                let orCommand = OrCommand()
                let asm = orCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
            case .not:
                let notCommand = NotCommand()
                let asm = notCommand.convert()
                write(url: writeURL, text: "\(asm)\n\n")
        }
    }

    func writePushPop(command: CommandPushPopType, segment: String, index: Int) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        switch command {
            case .push:
                let pushCommand = PushCommand(segment: segment, index: index, vmFileName: vmFileName)
                write(url: writeURL, text: "\(pushCommand.convert())\n\n")
            case .pop:
                let popCommand = PopCommand(segment: segment, index: index, vmFileName: vmFileName)
                write(url: writeURL, text: "\(popCommand.convert())\n\n")
        }
    }

    // VMの初期化
    func writeInit() {

    }

    // labelコマンド
    func writeLabel(label: String, functionName: String?) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let labelCommand = LabelCommand(label: label, functionName: functionName)
        let asm = labelCommand.convert()
        write(url: writeURL, text: "\(asm)\n\n")
    }

    // gotoコマンド
    func writeGoto(label: String, functionName: String?) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let gotoCommand = GotoCommand(label: label, functionName: functionName)
        let asm = gotoCommand.convert()
        write(url: writeURL, text: "\(asm)\n\n")
    }

    // if-gotoコマンド
    func writeIf(label: String, functionName: String?) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let ifGotoCommand = IfGotoCommand(label: label, functionName: functionName)
        let asm = ifGotoCommand.convert()
        write(url: writeURL, text: "\(asm)\n\n")
    }

    // callコマンド
    func writeCall(functionName: String, numArgs: Int) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let callCommand = CallCommand(functionName: functionName, numArgs: numArgs)
        let asm = callCommand.convert()
        write(url: writeURL, text: "\(asm)\n\n")
    }

    // bootstrapコマンド
    func writeBootstrap() {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let callCommand = CallCommand(functionName: "Sys.init", numArgs: 0)
        let bootstrapAsm = """
                           @256
                           D=A
                           @SP
                           M=D

                           """
        let asm = """
                  \(bootstrapAsm) 
                  \(callCommand.convert())
                  """
        write(url: writeURL, text: "\(asm)\n\n")
    }

    // returnコマンド
    func writeReturn() {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let returnCommand = ReturnCommand()
        let asm = returnCommand.convert()
        write(url: writeURL, text: "\(asm)\n")
    }

    // functionコマンド
    func writeFunction(functionName: String, numLocals: Int) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        let functionCommand = FunctionCommand(functionName: functionName, numLocals: numLocals)
        let asm = functionCommand.convert()
        write(url: writeURL, text: "\(asm)\n")
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