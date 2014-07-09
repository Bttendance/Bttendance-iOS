//
//  BTAPIs.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 11..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTAPIs.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "AFNetworkActivityLogger.h"
#import "AFResponseSerializer.h"
#import "BTUserDefault.h"
#import "BTUUID.h"
#import "User.h"
#import "Course.h"
#import "School.h"
#import "Post.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Error.h"
#import "Email.h"
#import "CatchPointViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BTColor.h"

@implementation BTAPIs

static UIAlertView *Ooooppss;

+ (AFHTTPRequestOperationManager *)sharedAFManager
{
	static AFHTTPRequestOperationManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFResponseSerializer serializer];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
#ifdef DEBUG
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
	});
	return manager;
}

+ (void)failureHandleWithError:(NSError *)error {
    
    //401 : Auto Sign Out
    //441 : Update Recommended
    //442 : Update Required
    
    NSInteger statusCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    Error *errorJson = [[Error alloc] initWithDictionary:[[error userInfo] objectForKey:AFResponseSerializerKey]];
    
    if (statusCode == 441) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:errorJson.title
                                           message:errorJson.message
                                          delegate:self
                                 cancelButtonTitle:@"Confirm"
                                 otherButtonTitles:@"Cancel", nil];
        alert.tag = statusCode;
        [alert show];
    } else if (statusCode == 503) {
        if (Ooooppss == nil) {
            NSString *message = @"Too many users are connecting at the same time, please try again later.";
            Ooooppss = [[UIAlertView alloc] initWithTitle:@"Ooooppss!"
                                               message:message
                                              delegate:self
                                     cancelButtonTitle:@"Confirm"
                                     otherButtonTitles:nil];
            Ooooppss.tag = statusCode;
        }
        
        if (!Ooooppss.visible)
            [Ooooppss show];
    } else { //(log, toast, alert)
        if ([errorJson.type isEqualToString:@"log"]) {
            NSLog(@"Error : %@", errorJson.message);
        } else if ([errorJson.type isEqualToString:@"toast"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSArray *viewControllers = [appDelegate.navController viewControllers];
            UIViewController *currentViewController = viewControllers[[viewControllers count] - 1];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentViewController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.color = [BTColor BT_cyan:0.7];
            hud.detailsLabelText = errorJson.message;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14.0f];
            hud.yOffset = - currentViewController.view.frame.size.height / 2 + 104;
            hud.margin = 14.0f;
            [hud hide:YES afterDelay:1.5];
        } else if ([errorJson.type isEqualToString:@"alert"]) {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:errorJson.title
                                               message:errorJson.message
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            alert.tag = statusCode;
            [alert show];
        }
    }
}

#pragma UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 401) {
        [BTUserDefault clear];
        CatchPointViewController *catchView = [[CatchPointViewController alloc] initWithNibName:@"CatchPointViewController" bundle:nil];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.navController pushViewController:catchView animated:NO];
    }
    
    if ((alertView.tag == 441 || alertView.tag == 442) && buttonIndex == 0) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/apple-store/id829410376?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

#pragma APIs
+ (void)signUpWithFullName:(NSString *)full_name
                  username:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSDictionary *params = @{@"username" : username,
                             @"email" : email,
                             @"full_name" : full_name,
                             @"password" : password,
                             @"device_type" : @"iphone",
                             @"device_uuid" : uuid};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/users/signup"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [BTUserDefault setUser:responseObject];
                             User *user = [[User alloc] initWithDictionary:responseObject];
                             success(user);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)autoSignInInSuccess:(void (^)(User *user))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"device_type" : @"iphone",
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"app_version" : appVersion};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/auto/signin"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure {
    
    NSString *uuid = [BTUUID representativeString:[BTUUID getUserService].UUID];
    NSDictionary *params = @{@"username" : username,
                             @"password" : password,
                             @"device_uuid" : uuid};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/signin"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)forgotPasswordWithEmail:(NSString *)email
                        success:(void (^)(Email *email))success
                        failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"email" : email};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/forgot/password"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Email *email = [[Email alloc] initWithDictionary:responseObject];
                            success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)updateProfileImage:(NSString *)profile_image
                   success:(void (^)(User *user))success
                   failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"profile_image" : profile_image};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/profile_image"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)updateFullName:(NSString *)full_name
               success:(void (^)(User *user))success
               failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"full_name" : full_name};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/full_name"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)updateEmail:(NSString *)email
            success:(void (^)(User *user))success
            failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"email" : email};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/users/update/email"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)feedWithPage:(NSInteger)page
             success:(void (^)(NSArray *posts))success
             failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"page" : [NSString stringWithFormat: @"%d", (int)page]};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/feed"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *posts = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                Post *post = [[Post alloc] initWithDictionary:dic];
                                [posts addObject:post];
                            }
                            success(posts);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)coursesInSuccess:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                              @"password" : [BTUserDefault getPassword]};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *courses = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                Course *course = [[Course alloc] initWithDictionary:dic];
                                [courses addObject:course];
                            }
                            success(courses);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)searchUser:(NSString *)search_id
           success:(void (^)(User *user))success
           failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"search_id" : search_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/users/search"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)updateNotificationKey:(NSString *)notification_key
                      success:(void (^)(User *user))success
                      failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"device_uuid" : [BTUserDefault getUUID],
                             @"notification_key" : notification_key};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/devices/update/notification_key"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)allSchoolsAtSuccess:(void (^)(NSArray *schools))success
                    failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword]};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/schools/all"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *schools = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                School *school = [[School alloc] initWithDictionary:dic];
                                [schools addObject:school];
                            }
                            success(schools);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)coursesForSchool:(NSString *)school_id
                 success:(void (^)(NSArray *courses))success
                 failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"school_id" : school_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/schools/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *courses = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                Course *course = [[Course alloc] initWithDictionary:dic];
                                [courses addObject:course];
                            }
                            success(courses);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)enrollSchool:(NSString *)school_id
            identity:(NSString *)student_id
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"school_id" : school_id,
                             @"student_id" : student_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/schools/enroll"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)createCourseRequestWithName:(NSString *)name
                             number:(NSString *)number
                             school:(NSString *)school_id
                      professorName:(NSString *)professor_name
                            success:(void (^)(Email *email))success
                            failure:(void (^)(NSError *error))failure {
    
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"name" : name,
                             @"number" : number,
                             @"school_id" : school_id,
                             @"professor_name" : professor_name};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/courses/create/request"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Email *email = [[Email alloc] initWithDictionary:responseObject];
                             success(email);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)attendCourse:(NSString *)course_id
             success:(void (^)(User *user))success
             failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/attend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)dettendCourse:(NSString *)course_id
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/dettend"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [BTUserDefault setUser:responseObject];
                            User *user = [[User alloc] initWithDictionary:responseObject];
                            success(user);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
    
}

+ (void)feedForCourse:(NSString *)course_id
                 page:(NSInteger)page
              success:(void (^)(NSArray *posts))success
              failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id,
                             @"page" : [NSString stringWithFormat: @"%d", (int)page]};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/feed"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *posts = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                Post *post = [[Post alloc] initWithDictionary:dic];
                                [posts addObject:post];
                            }
                            success(posts);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)studentsForCourse:(NSString *)course_id
                  success:(void (^)(NSArray *simpleUsers))success
                  failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/students"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSMutableArray *simpleUsers = [NSMutableArray array];
                            for (NSDictionary *dic in responseObject) {
                                SimpleUser *simpleUser = [[SimpleUser alloc] initWithDictionary:dic];
                                [simpleUsers addObject:simpleUser];
                            }
                            success(simpleUsers);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)addManagerWithCourse:(NSString *)course_id
                     manager:(NSString *)manager
                     success:(void (^)(Course *course))success
                     failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id,
                             @"manager" : manager};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/add/manager"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Course *course = [[Course alloc] initWithDictionary:responseObject];
                            success(course);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)gradesWithCourse:(NSString *)course_id
                 success:(void (^)(NSArray *simpleUsers))success
                 failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/courses/grades"]
                     parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSMutableArray *simpleUsers = [NSMutableArray array];
                         for (NSDictionary *dic in responseObject) {
                             SimpleUser *simpleUser = [[SimpleUser alloc] initWithDictionary:dic];
                             [simpleUsers addObject:simpleUser];
                         }
                         success(simpleUsers);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [self failureHandleWithError:error];
                         failure(error);
                     }];
}

+ (void)exportGradesWithCourse:(NSString *)course_id
                       success:(void (^)(Email *email))success
                       failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/courses/export/grades"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Email *email = [[Email alloc] initWithDictionary:responseObject];
                            success(email);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)startAttendanceWithCourse:(NSString *)course_id
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure {

    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/attendance"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
    
}

+ (void)startClickerWithCourse:(NSString *)course_id
                       message:(NSString *)message
                   choiceCount:(NSString *)choice_count
                       success:(void (^)(Post *post))success
                       failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id,
                             @"message" : message,
                             @"choice_count" : choice_count};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/start/clicker"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];    
}

+ (void)createNoticeWithCourse:(NSString *)course_id
                      message:(NSString *)message
                      success:(void (^)(Post *post))success
                      failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"course_id" : course_id,
                             @"message" : message};
    
    [[self sharedAFManager] POST:[BTURL stringByAppendingString:@"/posts/create/notice"]
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             Post *post = [[Post alloc] initWithDictionary:responseObject];
                             success(post);
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             [self failureHandleWithError:error];
                             failure(error);
                         }];
}

+ (void)fromCoursesWithCourses:(NSArray *)course_ids
                       success:(void (^)(NSArray *attendanceIDs))success
                       failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[BTUserDefault getUsername] forKey:@"username"];
    [params setObject:[BTUserDefault getPassword] forKey:@"password"];
    for (int i = 0; i < course_ids.count; i++)
        [params setObject:[NSString stringWithFormat:@"%@", course_ids[i]] forKey:@"course_ids"];
    
    [[self sharedAFManager] GET:[BTURL stringByAppendingString:@"/attendances/from/courses"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            success(responseObject);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)foundDeviceWithAttendance:(NSString *)attendance_id
                             uuid:(NSString *)uuid
                          success:(void (^)(Attendance *attendance))success
                          failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"attendance_id" : attendance_id,
                             @"uuid" : uuid};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/found/device"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithDictionary:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)checkManuallyWithAttendance:(NSString *)attendance_id
                               user:(NSString *)user_id
                            success:(void (^)(Attendance *attendance))success
                            failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"attendance_id" : attendance_id,
                             @"user_id" : user_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/attendances/check/manually"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Attendance *attendance = [[Attendance alloc] initWithDictionary:responseObject];
                            success(attendance);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)connectWithClicker:(NSString *)clicker_id
                    socket:(NSString *)socket_id
                   success:(void (^)(Clicker *clicker))success
                   failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"clicker_id" : clicker_id,
                             @"socket_id" : socket_id};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/clickers/connect"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Clicker *clicker = [[Clicker alloc] initWithDictionary:responseObject];
                            success(clicker);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

+ (void)clickWithClicker:(NSString *)clicker_id
                  choice:(NSString *)choice_number
                 success:(void (^)(Clicker *clicker))success
                 failure:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{@"username" : [BTUserDefault getUsername],
                             @"password" : [BTUserDefault getPassword],
                             @"clicker_id" : clicker_id,
                             @"choice_number" : choice_number};
    
    [[self sharedAFManager] PUT:[BTURL stringByAppendingString:@"/clickers/click"]
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            Clicker *clicker = [[Clicker alloc] initWithDictionary:responseObject];
                            success(clicker);
                        } failure:^(AFHTTPRequestOperation *opration, NSError *error) {
                            [self failureHandleWithError:error];
                            failure(error);
                        }];
}

@end
