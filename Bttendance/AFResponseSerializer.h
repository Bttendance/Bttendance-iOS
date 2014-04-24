//
//  AFResponseSerializer.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLResponseSerialization.h>

static NSString * const AFResponseSerializerKey = @"AFResponseSerializerKey";

@interface AFResponseSerializer : AFJSONResponseSerializer

@end
