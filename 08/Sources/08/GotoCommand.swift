import Foundation

class GotoCommand {
    let label: String
    let functionName: String?

    init(label: String, functionName: String?) {
        self.label = label
        self.functionName = functionName
    }

}

extension GotoCommand: Command {

    func convert() -> String {
        let convertedLabel: String = {
            if let functionName = functionName {
                return "\(functionName)$\(label)"
            } else {
                return label
            }
        }()

        let asm = """
                  // goto
                  @\(convertedLabel)
                  0;JMP
                  """
        return asm
    }

}