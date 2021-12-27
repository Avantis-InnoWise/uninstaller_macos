import Foundation

final class FilesManager {
    func findDuplicatedFiles(completion: @escaping ([File]) -> Void) {
        getAllFiles(in: FileManager.default.homeDirectoryForCurrentUser.path) { files in
            var duplicatedFiles = files
            let uniqueFileNames = Set(files.compactMap { $0.name })
            for uniqueFileName in uniqueFileNames {
                guard let index = duplicatedFiles.firstIndex(where: { $0.name == uniqueFileName })
                else { continue }
                duplicatedFiles.remove(at: index)
            }
            completion(duplicatedFiles.filter { !$0.isDirectory })
        }
    }
    
    func findOldFiles(completion: @escaping ([File]) -> Void) {
        getAllFiles { files in
            let oldFiles = files.filter {
                let fileModifiedDateIntervalInSeconds =
                abs($0.dateModified?.timeIntervalSinceNow ?? Date().timeIntervalSinceReferenceDate)
                
                let fileModifiedDateIntervalInDays =
                fileModifiedDateIntervalInSeconds * 0.00001157
                
                let fileAccessedDateIntervalInSeconds =
                abs($0.dateAccessed?.timeIntervalSinceNow ?? Date().timeIntervalSinceReferenceDate)
                
                let fileAccessedDateIntervalInDays =
                fileAccessedDateIntervalInSeconds * 0.00001157
                
                return fileModifiedDateIntervalInDays > 90 && fileAccessedDateIntervalInDays > 90
            }
            completion(oldFiles)
        }
    }
    
    func getAllFiles(
        in directory: String? = nil,
        with name: String = "",
        completion: @escaping ([File]) -> Void
    ) {
        var files = [File]()
        
        let resourceKeys: [URLResourceKey] = [
            .nameKey,
            .contentModificationDateKey,
            .isDirectoryKey
        ]
        let enumerator = FileManager.default.enumerator(
            at: URL(fileURLWithPath: directory ?? "/"),
            includingPropertiesForKeys: [
                .nameKey,
                .contentAccessDateKey,
                .contentModificationDateKey,
                .isDirectoryKey
            ],
            options: [.skipsPackageDescendants, .skipsHiddenFiles]
        )
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.setTarget(queue: .global(qos: .userInteractive))
        
        while let element = enumerator?.nextObject() as? URL {
            dispatchGroup.enter()
            
            guard let resources = try? element.resourceValues(forKeys: Set(resourceKeys)),
                  let fileName = resources.name,
                  let isDirectory = resources.isDirectory
            else {
                dispatchGroup.leave()
                continue
            }
            
            guard name.isEmpty || fileName.lowercased().contains(name)
            else {
                dispatchGroup.leave()
                continue
            }
            
            files.append(
                File(
                    path: element.path,
                    isDirectory: isDirectory,
                    dateModified: resources.contentModificationDate,
                    dateAccessed: resources.contentAccessDate,
                    name: fileName
                )
            )
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(files)
        }
    }
    
    func deleteFile(_ filePath: String, completion: (Error?) -> Void) {
        do {
            try FileManager.default.removeItem(atPath: filePath)
            completion(nil)
        } catch {
            print(error)
            completion(error)
        }
    }
}
