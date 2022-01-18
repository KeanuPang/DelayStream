import ArgumentParser

struct Commander: ParsableCommand {
    @Argument(help: "The file path to read.")
    var filePath: [String] = []

    @Option(name: .shortAndLong, help: "delay milliseconds, default is 500ms.")
    var delay: Double?

    mutating func run() throws {
        if filePath.isEmpty {
            filePath = ["-"]
        }

        for f in filePath {
            guard let source = DelayStream.generateFileHandle(filePath: f) else { return }

            let stream = DelayStream(source: source)

            while let text = stream.read(delay ?? 500) {
                print(text)
            }
        }
    }
}

Commander.main()
