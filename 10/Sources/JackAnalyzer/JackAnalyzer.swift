class JackAnalyzer {

    var tokenizers = [JackTokenizer]()

    init(sources: [String]) {
        tokenizers = sources.map {
            JackTokenizer(source: $0)
        }
    }

    func analyze() {
        tokenizers.forEach { _ in
            print("analyze!")
        }
    }

}