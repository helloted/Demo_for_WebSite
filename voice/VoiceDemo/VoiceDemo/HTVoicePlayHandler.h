//
//  HTVoicePlayHandler.h
//  TSho
//
//  Created by iMac on 2017/9/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
@import AVFoundation;
@import AudioToolbox;

@interface HTVoicePlayHandler : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer      *player;

+ (instancetype)sharedHandler;

- (void)startPlayWithPath:(NSString *)path;

- (void)pausePlay;

- (void)resumePlay;

- (void)stopPlay;

@end
