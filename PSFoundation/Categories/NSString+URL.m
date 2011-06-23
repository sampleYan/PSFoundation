//
//  NSString+URL.m
//  PSFoundation
//
//  Includes code by the following:
//   - Shaun Harrison.     2009.  BSD.
//   - Sam Soffes.         2010.  MIT.
//   - Pete Steinberger.   2010.  MIT.
//   - Zachary Waldowski.  2011.  MIT.
//

#import "NSString+URL.h"

@implementation NSString (PSStringURL)

- (NSString *)URLEncodedString {
    PS_RETURN_AUTORELEASED(NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           ps_unretainedPointer(self),
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]<>"),
                                                                           kCFStringEncodingUTF8)));
}

- (NSString *)URLDecodedString {
    PS_RETURN_AUTORELEASED(NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           ps_unretainedPointer(self),
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8)));
}

- (NSString *)URLEncodedParameterString {
    NSString *firstPass = NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    ps_unretainedPointer(self),
                                                                                    CFSTR(" "),
                                                                                    CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                    kCFStringEncodingUTF8));
    if (firstPass) {
        NSMutableString *secondPass = [firstPass mutableCopy];
        PS_RELEASE_NIL(firstPass);
        [secondPass replaceOccurrencesOfString:@" "
                                    withString:@"+"
                                       options:0
                                         range:NSMakeRange(0, secondPass.length)];
        PS_RETURN_AUTORELEASED(secondPass);
    }
	return self;
}

- (NSString *)URLDecodedParameterString {
    return [[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSString*) stringByReplacingPercentEscapesOnce {
	NSString *unescaped = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//self may be a string that looks like an invalidly escaped string,
	//eg @"100%", in that case it clearly wasn't escaped,
	//so we return it as our unescaped string.
	return unescaped ? unescaped : self;
}

- (NSString*) stringByAddingPercentEscapesOnce {
	return [[self stringByReplacingPercentEscapesOnce] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlWithoutParameters {
    NSRange r;
    NSString *newUrl = nil;
    
    r = [self rangeOfString:@"?" options: NSBackwardsSearch];
    if (r.length > 0)
        newUrl = [self substringToIndex: NSMaxRange (r) - 1];
    else
        newUrl = self;
    
    return newUrl;
}

- (NSURL *)ps_URL; {
    NSURL *url = nil;
    if ([self hasPrefix:@"http"]) {
        url = [NSURL URLWithString:self];
    }else if([self length] > 0) {
        url = [NSURL fileURLWithPath:self];
    }
    
    return url;
}

- (NSString *)removeQuotes {
	NSString __ps_autoreleasing *ret = PS_AUTORELEASE([self copy]);
        
	if ([self characterAtIndex:0] == '"') {
		ret = [ret substringFromIndex:1];
	}
    
	if ([self characterAtIndex:self.length - 1] == '"') {
		ret = [ret substringToIndex:self.length - 2];
	}
	
	return ret;
}

@end

@implementation NSMutableString (PSStringURL)

- (NSMutableString *)appendParameter:(id)param name:(NSString *)name {
    if (!param) {
        DDLogWarn(@"Parameter is empty, not adding.");
        return self;
    }
    
    BOOL needsQMark = [self rangeOfString:@"?" options:0].location == NSNotFound;
    if (needsQMark) {
        [self appendString:@"?"];
    }
    
    BOOL charOnEnd = [self hasSuffix:@"&"] || [self hasSuffix:@"?"];
    if (!charOnEnd) {
        [self appendString:@"&"];
    }
    
    if ([param isKindOfClass:[NSArray class]])
        [(NSArray *)param enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self appendFormat:@"%@%@[]=%@", (idx > 0 ? @"&" : @""), name, obj];
        }];
    else
        [self appendFormat:@"%@=%@", name, param];
    
    return self;
}

@end
