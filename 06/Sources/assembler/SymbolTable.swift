import Foundation

class SymbolTable {

    private var table: [String: Int] = [String: Int]()
    var userAddress = 16

    init() {
        table["SP"] = 0
        table["LCL"] = 1
        table["ARG"] = 2
        table["THIS"] = 3
        table["THAT"] = 4
        table["R0"] = 0
        table["R1"] = 1
        table["R2"] = 2
        table["R3"] = 3
        table["R4"] = 4
        table["R5"] = 5
        table["R6"] = 6
        table["R7"] = 7
        table["R8"] = 8
        table["R9"] = 9
        table["R10"] = 10
        table["R11"] = 11
        table["R12"] = 12
        table["R13"] = 13
        table["R14"] = 14
        table["R15"] = 15
        table["SCREEN"] = 16384
        table["KED"] = 24576
    }

    // シンボルに対応するアドレスを追加
    func addEntry(symbol: String, address: Int) {
        table[symbol] = address
    }

    // シンボルがテーブルに存在するか
    func contains(symbol: String) -> Bool {
        return table.contains(where: { 
            return $0.key == symbol
        })
    }

    // シンボルのアドレスを取得
    func getAddress(symbol: String) -> Int {
        return table[symbol] ?? 0
    }
}
