import Foundation

func main(path: String) {
    var readURL = URL(fileURLWithPath: path)
    let pathPrefix = (path as NSString).deletingPathExtension
    let writeFileName = "\(pathPrefix).hack"
    let writeURL = URL(fileURLWithPath: writeFileName)
    removeFile(fileURL: writeURL)
    let code = Code()
    let symbolTable = SymbolTable()
    do {
        let parser1 = Parser(path: path)
        var cAddressForNext = 0
        while parser1.hasMoreCommands() {
            parser1.advance()
            let commandType = parser1.commandType()
            switch commandType {
                case .A_COMMAND:
                    let symbol = parser1.symbol()
                    guard !symbol.isEmpty else {
                        continue 
                    }
                    cAddressForNext += 1

                    if let num = Int16(symbol) {
                        continue
                    }

                    if !symbolTable.contains(symbol: symbol) {
                        guard !parser1.isLCommandType(symbol: symbol) else {
                            continue
                        }
                        
                        symbolTable.addEntry(symbol: symbol, address: symbolTable.userAddress)
                        symbolTable.userAddress += 1
                        continue
                    }
                case .C_COMMAND:
                    cAddressForNext += 1
                case .L_COMMAND: 
                    let symbol = parser1.symbol()
                    guard !symbol.isEmpty else {
                        continue 
                    }
                    if !symbolTable.contains(symbol: symbol) {
                        symbolTable.addEntry(symbol: symbol, address: cAddressForNext)
                        continue
                    } 
                    continue
            }
        }
    }

    do {
        let parser2 = Parser(path: path)
        while parser2.hasMoreCommands() {
            parser2.advance()
            let commandType = parser2.commandType()
            switch commandType {
                case .A_COMMAND:
                    let symbol = parser2.symbol()
                    guard !symbol.isEmpty else {
                        continue 
                    }
                    if let num = Int16(symbol) {
                        let binaryString = num.binaryString
                        print(binaryString)
                        write(url: writeURL, text: "\(binaryString)\n")
                        continue
                    }
                    if symbolTable.contains(symbol: symbol) {
                        let address = symbolTable.getAddress(symbol: symbol)
                        let binaryString = Int16(address).binaryString
                        print(binaryString)
                        write(url: writeURL, text: "\(binaryString)\n")
                    } else {
                        print("not found: \(symbol)")
                    }
                case .C_COMMAND:
                    let comp = code.comp(nimonic: parser2.comp())
                    let dest = code.dest(nimonic: parser2.dest())
                    let jump = code.jump(nimonic: parser2.jump())
                    let binaryString = "111\(comp)\(dest)\(jump)"
                    print(binaryString)
                    write(url: writeURL, text: "\(binaryString)\n")
                default: 
                    continue
            }
        }
    }
}

func write(url: URL, text: String) -> Bool {
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

func removeFile(fileURL: URL) {
    do {
        try FileManager.default.removeItem(at: fileURL)
    } catch {
        print("delete file error")
    }
}

if CommandLine.arguments.count == 2  {
    main(path: CommandLine.arguments[1])
}
