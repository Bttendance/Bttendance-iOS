//
//  BTTable.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTTable.h"

@implementation BTTable

+ (BTTable *)sharedInstance {
    static BTTable *table;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [[BTTable alloc]init];
    });
    
    return table;
    
}

@end
