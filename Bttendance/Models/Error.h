//
//  Error.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

@property(strong, nonatomic) NSString  *type; //(log, toast, alert)
@property(strong, nonatomic) NSString  *title;
@property(strong, nonatomic) NSString  *message;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
