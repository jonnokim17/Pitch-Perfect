//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jonathan Kim on 7/18/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var fileURL: NSURL!
    var title: String!

    init(fileURL: NSURL, title: String) {
        self.fileURL = fileURL
        self.title = title
    }
}
