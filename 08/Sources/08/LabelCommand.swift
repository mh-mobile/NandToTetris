import Foundation

class LabelCommand {
    let label: String

    init(label: String) {
        self.label = label
    }

}

extension LabelCommand: Command {

    func convert() -> String {
        let asm = """
                  // label
                  (\(label))
                  """
        return asm
    }

}