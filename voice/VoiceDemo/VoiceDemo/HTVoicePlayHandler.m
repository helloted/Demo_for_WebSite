//
//  HTVoicePlayHandler.m
//  TSho
//
//  Created by iMac on 2017/9/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTVoicePlayHandler.h"

@implementation HTVoicePlayHandler

+ (instancetype)sharedHandler{
    static HTVoicePlayHandler *_singleObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleObj = [[self alloc] init];
    });
    return _singleObj;
}


- (AVAudioPlayer *)player{
    if (!_player) {
        _player = [[AVAudioPlayer alloc]init];
    }
    return _player;
}

- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (void)startPlayWithPath:(NSString *)path{
    if (_player) { // 如果正在播放上一段录音，则停止
        [_player stop];
    }
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    if (path&& [self fileSizeAtPath:path]) {
        self.player = [self.player initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        self.player.delegate = self;
        [self.player play];
        NSLog(@"开始播放");
    }else{
        NSLog(@"no voice");
    }
}


- (void)pausePlay{
    [self.player pause];
}

- (void)resumePlay{
    [self.player play];
}


- (void)stopPlay{
    [self.player stop];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"finish---play");
}


@end
