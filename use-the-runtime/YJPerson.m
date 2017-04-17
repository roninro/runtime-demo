//
//  YJPerson.m
//  use-the-runtime
//
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "YJPerson.h"
#import <objc/objc-runtime.h>

@implementation YJPerson
{
    @private
    NSString *private_nano;
}

- (instancetype)initWithName:(NSString *)name Age:(NSInteger)age {
    self = [super init];
    if (!self) {
        return nil;
    }
    _name = [name copy];
    _age = age;
    _userId = [NSString stringWithFormat:@"%@_2234",_name];
    _description1 = [NSString stringWithFormat:@"%@: %ld : 1",_name, _age];
    _description2 = [NSString stringWithFormat:@"%@: %ld : 2",_name, _age];
    _description3 = [NSString stringWithFormat:@"%@: %ld : 3",_name, _age];
    private_nano = @"private_nano";
    return self;
    
}

- (NSDictionary *)allProperties {
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *resultDict = @{}.mutableCopy;
    for (NSUInteger i=0; i<count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        if (propertyValue) {
            resultDict[name] = propertyValue;
        }
        else {
            resultDict[name] = @"Value is Nil";
        }
    }
    free(properties);
    return resultDict;
}

- (NSDictionary *)allIvars {
    unsigned int count= 0;
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (NSUInteger i=0; i<count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        id varValue = [self valueForKey:name];
        if (varValue) {
            dict[name] = varValue;
        }
        else {
            dict[name] = @"Value is Nil";
        }
    }
    free(ivars);
    return dict;
}

- (NSDictionary *)allMethods {
    unsigned int count= 0;
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    Method *methods = class_copyMethodList([self class], &count);
    for (NSUInteger i=0; i<count; i++) {
        SEL methodSEL = method_getName(methods[i]);
        const char *methodName = sel_getName(methodSEL);
        NSString *name = [NSString stringWithUTF8String:methodName];
        int arguments = method_getNumberOfArguments(methods[i]);
        dict[name] = @(arguments - 2);  // id, SEL,...
    }
    free(methods);
    return dict;
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    /*
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.age = [aDecoder decodeIntegerForKey:@"age"];
    self.description1 = [aDecoder decodeObjectForKey:@"description1"];
    self.description2 = [aDecoder decodeObjectForKey:@"description2"];
    self.description3 = [aDecoder decodeObjectForKey:@"description3"];
    *   ...
    */

    NSArray *ivar_list = Ivar_list([self class]);
    for (NSString *property in ivar_list) {
        [self setValue:[aDecoder decodeObjectForKey:property] forKey:property];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    /*
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.description1 forKey:@"description1"];
    [aCoder encodeObject:self.description2 forKey:@"description2"];
    [aCoder encodeObject:self.description3 forKey:@"description3"];
     * ...
     */

    NSArray *ivar_list = Ivar_list([self class]);
    for (NSString *property in ivar_list) {
        [aCoder encodeObject:[self valueForKey:property] forKey:property];
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@",[self allIvars]];
}


@end


NSString *ArchivePath() {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [path stringByAppendingString:@"person"];
}

NSArray *Ivar_list(Class class) {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(class, &count);
    NSMutableArray *ivar_list = @[].mutableCopy;
    for (NSUInteger i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [ivar_list addObject:key];
    }
    free(ivars);
    return ivar_list;
}
