//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by 郭坤 on 15/10/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(pathUrl path: NSURL, fileTitle: String!) {
        filePathUrl = path
        title = fileTitle
    }
}
