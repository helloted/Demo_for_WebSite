//
//  HTVoiceRecordHandler.h
//  TSho
//
//  Created by iMac on 2017/9/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTVoiceRecordHandler : NSObject

@property (nonatomic, copy)NSString       *voicePath;

+ (instancetype)sharedHandler;

- (void)startRecord;

- (void)pauseRecord;

- (void)resumeRecord;

- (void)stopRecord;

@end
