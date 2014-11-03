//
//  Error.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Error : RLMObject

typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorType_Log,
    ErrorType_Toast,
    ErrorType_Alert
};

@property NSString          *type;
@property NSString          *title;
@property NSString          *message;

- (ErrorType)getErrorType;

@end
