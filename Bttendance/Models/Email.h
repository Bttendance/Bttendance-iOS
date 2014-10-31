//
//  Email.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Email : NSObject

@property NSString          *email;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
