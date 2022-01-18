//
//  DelayStream.swift
//
//
//  Created by Keanu Pang on 2022/1/18.
//

import Foundation

public final class DelayStream {
    private let delimiter = CharacterSet.newlines

    private var source: FileHandle
    private var buffer: Scanner?

    init(source: FileHandle) {
        self.source = source
    }

    static func generateFileHandle(filePath: String) -> FileHandle? {
        if filePath == "-" {
            return FileHandle.standardInput
        }

        return FileHandle(forReadingAtPath: filePath)
    }

    func read(_ msForDelay: Double = 500) -> String? {
        guard isBufferReady() else { return nil }

        var token: NSString?
        guard buffer?.scanUpToCharacters(from: delimiter, into: &token) == true else { return nil }
        guard let token = token as String? else { return nil }

        defer {
            usleep(UInt32(msForDelay * 1000))
            buffer?.scanCharacters(from: delimiter, into: nil)
        }

        return token
    }

    private func isBufferReady() -> Bool {
        if buffer?.isAtEnd ?? true {
            let data = source.availableData

            guard data.count > 0 else { return true }

            if let nextData = String(data: data, encoding: .utf8) {
                buffer = Scanner(string: nextData)
            }
        }

        return !(buffer?.isAtEnd ?? true)
    }
}
