//
//  YJPerson.h
//  use-the-runtime
//
//  Copyright © 2017年 mervin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJPerson : NSObject<NSCoding>
{
    NSString *_userId;
}

@property (nonatomic, assign)NSInteger age;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *description1;
@property (nonatomic, copy)NSString *description2;
@property (nonatomic, copy)NSString *description3;

- (instancetype)initWithName:(NSString *)name Age:(NSInteger)age;

- (NSDictionary *) allProperties;
- (NSDictionary *) allIvars;
- (NSDictionary *) allMethods;

@end

NSString *ArchivePath();  // archive path
NSArray *Ivar_list(Class class);
