//
//  Error.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Error : NSObject

//(log, toast, alert)
@property NSString          *type;
@property NSString          *title;
@property NSString          *message;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
