//
//  HTVoiceConvertHandler.h
//  VoiceDemo
//
//  Created by iMac on 2017/9/26.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTVoiceConvertHandler : NSObject

- (Boolean)convertFromWAV:(NSString *)wavPath toAMR:(NSString *)amrPath;

- (Boolean)convertFromAMR:(NSString *)amrPath toWAV:(NSString *)wavPath;

@end
