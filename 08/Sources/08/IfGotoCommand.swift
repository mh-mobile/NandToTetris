import Foundation

class IfGotoCommand {
    let label: String
    let functionName: String?

    init(label: String, functionName: String?) {
        self.label = label
        self.functionName = functionName
    }

}

extension IfGotoCommand: Command {

    func convert() -> String {
        let convertedLabel: String = {
            if let functionName = functionName {
                return "\(functionName)$\(label)"
            } else {
                return label
            }
        }()

        let asm = """
                  // if-goto
                  @SP
                  AM=M-1
                  D=M
                  @\(convertedLabel)
                  D;JNE
                  """
        return asm
    }

}