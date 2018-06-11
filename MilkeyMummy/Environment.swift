//
//  Environment.swift
//  MilkeyMummy
//
//  Created by 齋藤　航平 on 2018/06/11.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

class Environment {
    
    enum FlaverType {
        case develop
        case staging
        case production
    }
    
    enum BuildType {
        case debug
        case release
    }
    
    static func getFlaverType() -> FlaverType {
        #if DEVELOP_DEBUG
        return .develop
        #elseif DEVELOP_RELEASE
        return .develop
        #elseif STAGING_DEBUG
        return .staging
        #elseif STAGING_RELEASE
        return .staging
        #elseif PRODUCTION_DEBUG
        return .production
        #elseif PRODUCTION_RELEASE
        return .production
        #endif
    }
    
    static func getBuildType() -> BuildType {
        #if DEVELOP_DEBUG
        return .debug
        #elseif DEVELOP_RELEASE
        return .release
        #elseif STAGING_DEBUG
        return .debug
        #elseif STAGING_RELEASE
        return .release
        #elseif PRODUCTION_DEBUG
        return .debug
        #elseif PRODUCTION_RELEASE
        return .release
        #endif
    }
    
}
