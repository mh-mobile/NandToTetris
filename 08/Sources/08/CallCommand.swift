import Foundation

class CallCommand {
    let functionName: String
    let numArgs: Int

    init(functionName: String, numArgs: Int) {
        self.functionName = functionName
        self.numArgs = numArgs
    }
}

extension CallCommand: Command {

    func convert() -> String {
        let asm = """
                  // call
                  """
        return asm
    }

}