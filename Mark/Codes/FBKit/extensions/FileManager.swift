//
//  FileManager.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import Foundation

extension FileManager {
    
    func createFinder( path: URL) {
        let mgr = FileManager.default
        var isDir:ObjCBool = ObjCBool(false)
        let isExist =  mgr.fileExists(atPath: path.path, isDirectory: &isDir)
        if isDir.boolValue != true ||  isExist == false {
            do {
                try mgr.createDirectory(atPath: path.path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Error:\(error)")
            }
            printt(path.path)
            printt("创建文件夹:\(path.lastPathComponent)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
