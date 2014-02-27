//
//  BTAPIs.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEV YES

#if DEV == YES
    #define BTURL @"http://bttendance-dev.herokuapp.com/api"
#else
    #define BTURL @"http://www.bttd.co/api"
#endif


@interface BTAPIs : NSObject

@end
