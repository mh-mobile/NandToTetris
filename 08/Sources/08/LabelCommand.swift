import Foundation

class LabelCommand {
    let label: String
    let functionName: String?

    init(label: String, functionName: String?) {
        self.label = label
        self.functionName = functionName
    }

}

extension LabelCommand: Command {

    func convert() -> String {
        let convertedLabel: String
        if let functionName  = functionName {
            convertedLabel = "\(functionName)$\(label)"
        } else {
            convertedLabel = label
        }
        let asm = """
                  // label
                  (\(convertedLabel))
                  """
        return asm
    }

}