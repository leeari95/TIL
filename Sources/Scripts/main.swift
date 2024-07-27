// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@MainActor
struct MarkdownUpdater {
    // MARK: - Constants
    private let basePath = "Sources/AriNote/TIL.docc/"
    private let fileManager = FileManager.default

    // MARK: - Helper Functions
    private func getMarkdownFiles(in path: String) throws -> [String] {
        let items = try fileManager.contentsOfDirectory(atPath: path)
        return items.filter { $0.hasSuffix(".md") && $0 != "TIL.md" }
    }

    private func getSortedFiles(in directoryPath: String) throws -> [String] {
        let directoryContents = try fileManager.contentsOfDirectory(atPath: directoryPath)
        return directoryContents
            .filter { $0.range(of: "^\\d{6}", options: .regularExpression) != nil }
            .sorted { String($0.prefix(6)) > String($1.prefix(6)) }
    }

    private func updateTopicsSection(in content: inout String, with files: [String]) {
        if let topicsRange = content.range(of: "## Topics") {
            content = String(content[..<topicsRange.upperBound])
        } else {
            content += "\n\n## Topics"
        }
        
        for file in files {
            let docName = file.replacingOccurrences(of: ".md", with: "")
            content += "\n- <doc:\(docName)>"
        }
    }

    // MARK: - Main Execution
    func updateMarkdownFiles() async throws {
        let mdFiles = try getMarkdownFiles(in: basePath)
        
        for mdFile in mdFiles {
            let mdFilePath = (basePath as NSString).appendingPathComponent(mdFile)
            let directoryName = (mdFile as NSString).deletingPathExtension
            let directoryPath = (basePath as NSString).appendingPathComponent(directoryName)
            
            let sortedFiles = try getSortedFiles(in: directoryPath)
            var fileContent = try String(contentsOfFile: mdFilePath, encoding: .utf8)
            
            updateTopicsSection(in: &fileContent, with: sortedFiles)
            
            try fileContent.write(toFile: mdFilePath, atomically: true, encoding: .utf8)
            
            print("Updated \(mdFile)")
        }
    }
}

// MARK: - Script Execution
do {
    let updater = MarkdownUpdater()
    try await updater.updateMarkdownFiles()
    exit(0)
} catch {
    print("An error occurred: \(error)")
    exit(1)
}
