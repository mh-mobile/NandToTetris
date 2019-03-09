import Foundation

class CodeWriter {
    var writeURL: URL?

    public init() {

    }

    func setFileName(fileName: String) {
        writeURL = URL(fileURLWithPath: fileName)
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        removeFile(fileURL: writeURL)
    }

    func writeArithmetic(command: String) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        guard let arithmeticType = CommandArithmeticType(rawValue: command) else { fatalError("arithmetic type error.") }
        switch arithmeticType {
            case .add:
                write(url: writeURL, text: "\(command)\n")
            case .sub:
                write(url: writeURL, text: "\(command)\n")
            case .neg:
                break
            case .eq:
                write(url: writeURL, text: "\(command)\n")
            case .gt:
                break
            case .lt:
                break
            case .and:
                break
            case .or:
                break
            case .not:
                break
        }
    }

    func writePushPop(command: CommandPushPopType, segment: String, index: Int) {
        guard let writeURL = writeURL else { fatalError("writeURL error.") }
        switch command {
            case .push:
                write(url: writeURL, text: "hello push!\n")
            case .pop:
                write(url: writeURL, text: "hello pop!\n")
        }
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