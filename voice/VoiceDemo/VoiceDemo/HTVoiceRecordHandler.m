//
//  HTVoiceRecordHandler.m
//  TSho
//
//  Created by iMac on 2017/9/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTVoiceRecordHandler.h"
#import <AVFoundation/AVFoundation.h>

@interface HTVoiceRecordHandler()

@property (nonatomic, strong)AVAudioRecorder    *voiceRecorder;
@property (nonatomic, strong)NSDictionary       *recorderSetting;
@property (nonatomic, copy)NSString             *amrPath;
@property (nonatomic, copy)NSString             *fileName;

@end

@implementation HTVoiceRecordHandler

+ (instancetype)sharedHandler{
    static HTVoiceRecordHandler *_singleObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleObj = [[self alloc] init];
    });
    return _singleObj;
}

/**
 *  录音的一些参数设置
 */
- (NSDictionary *)recorderSetting{
    if (!_recorderSetting) {
        _recorderSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                            [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                            [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                            nil];
    }
    return _recorderSetting;
}


/**
 *  开始录音
 */
- (void)startRecord{
    NSLog(@"----开始录音---");
    
    //根据当前时间生成文件名
    self.fileName = [self GetCurrentTimeString];
    //获取路径
    self.voicePath = [self GetPathByFileName:self.fileName ofType:@"wav"];
    
    self.voiceRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:self.voicePath] settings:self.recorderSetting error:nil];
    if ([self.voiceRecorder prepareToRecord]){
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //开始录音
        [self.voiceRecorder record];
    }
}


- (void)pauseRecord{
    [self.voiceRecorder pause];
}


- (void)resumeRecord{
    [self.voiceRecorder record];
}


- (void)stopRecord{
    [self.voiceRecorder stop];
}

#pragma makr - Others

/**
 *  当前时间字符串
 */
- (NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 *  生成录音文件路径
 */
- (NSString*)GetPathByFileName:(NSString *)fileName ofType:(NSString *)type{
    //创建文件夹
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/Voice", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileDirectory = [[[createPath stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}



@end
