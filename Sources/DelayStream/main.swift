import ArgumentParser

struct Commander: ParsableCommand {
    @Argument(help: "File path to read.")
    var filePath: [String] = []

    @Option(name: .shortAndLong, help: "Milli seconds to delay, default is 500ms.")
    var delay: Double?

    mutating func run() throws {
        if filePath.isEmpty {
            filePath = ["-"]
        }

        for f in filePath {
            guard let source = DelayStream.generateFileHandle(filePath: f) else {
                throw CleanExit.message("Invalid file path: \(f)")
            }

            let stream = DelayStream(source: source)

            while let text = stream.read(delay ?? 500) {
                print(text)
            }
        }
    }
}

Commander.main()
