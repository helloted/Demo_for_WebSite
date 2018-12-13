//
//  HTVoiceConvertHandler.mm
//  VoiceDemo
//
//  Created by iMac on 2017/9/26.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTVoiceConvertHandler.h"
#import "amrFileCodec.h"

@implementation HTVoiceConvertHandler

- (Boolean)convertFromAMR:(NSString *)amrPath toWAV:(NSString *)wavPath{
    return DecodeAMRFileToWAVEFile([amrPath cStringUsingEncoding:NSASCIIStringEncoding], [wavPath cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (Boolean)convertFromWAV:(NSString *)wavPath toAMR:(NSString *)amrPath{
    return EncodeWAVEFileToAMRFile([wavPath cStringUsingEncoding:NSASCIIStringEncoding], [amrPath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
}


@end
