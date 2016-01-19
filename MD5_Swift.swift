//
//  MD5_Swift.swift
//
//  Serx Lee
//
//  serx.lee@gmail.com
//
//  Created by Serx on 15/01/2016
//  Copyright © 2016 serx. All rights reserved.
//

/*
  	MD5加密算法,需要第三方库
  	#import <CommonCrypto/CommonDigest.h>
	#import "MBProgressHUD.h"
	第一行是为了写MD5算法，
	第二行是为了调用第三方的类库，MBProgressHUD
*/

import UIKit
import Foundation

extension String {

    func md5() -> String! {
    	
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
}
