//
//  BTUUID.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTUUID.h"
#import "KeychainItemWrapper.h"

@implementation BTUUID

+ (CBMutableService *)getUserService {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"BTDUUID" accessGroup:nil];
    NSString *_NSUUID_str = [keychain objectForKey:(__bridge id) kSecAttrAccount];
    if ([_NSUUID_str isEqual:@""]) {
        //make user unique service
        CBUUID *UserUUID = [CBUUID UUIDWithNSUUID:[[NSUUID alloc] init]];
        NSString *_BTD = @"Bttendance";
        NSData *BTD = [_BTD dataUsingEncoding:NSUTF8StringEncoding];
        CBMutableCharacteristic *UserChar = [[CBMutableCharacteristic alloc] initWithType:UserUUID properties:CBCharacteristicPropertyRead value:BTD permissions:CBAttributePermissionsReadable];
        CBMutableService *UserService = [[CBMutableService alloc] initWithType:UserUUID primary:YES];
        UserService.characteristics = @[UserChar];
        _NSUUID_str = [self representativeString:UserService.UUID];
        [keychain setObject:_NSUUID_str forKey:(__bridge id) kSecAttrAccount];
        return UserService;
    } else {
        CBUUID *UserUUID = [CBUUID UUIDWithString:_NSUUID_str];
        CBMutableCharacteristic *UserChar = [[CBMutableCharacteristic alloc] initWithType:UserUUID properties:CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadable];
        CBMutableService *UserService = [[CBMutableService alloc] initWithType:UserUUID primary:YES];
        UserService.characteristics = @[UserChar];
        return UserService;
    }
}

+ (NSString *)representativeString:(CBUUID *)_CBUUID {
    NSData *data = [_CBUUID data];
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity:16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++) {
        switch (currentByteIndex) {
            case 3:
            case 5:
            case 7:
            case 9:
                [outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]];
                break;
            default:
                [outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
        }
    }
    return outputString;
}

@end
