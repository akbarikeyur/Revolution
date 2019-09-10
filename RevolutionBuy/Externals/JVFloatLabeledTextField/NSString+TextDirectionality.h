//
//  NSString+TextDirectionality.h
//  JVFloatLabeledTextField
//
//  Copyright © 2016 Appster. All rights reserved.

#import <Foundation/Foundation.h>

/**
 * `JVTextDirection` indicates text directionality, such as Neutral, Left-to-Right, and Right-to-Left
 */
typedef NS_ENUM(NSUInteger, JVTextDirection) {
    /**
     * `JVTextDirectionNeutral` indicates text with no directionality
     */
    JVTextDirectionNeutral = 0,
    
    /**
     * `JVTextDirectionLeftToRight` indicates text left-to-right directionality
     */
    JVTextDirectionLeftToRight,
    
    /**
     * `JVTextDirectionRightToLeft` indicates text right-to-left directionality
     */
    JVTextDirectionRightToLeft,
};

/**
 * `NSString (TextDirectionality)` is an NSString category that is used to infer the text directionality of a string.
 */
@interface NSString (TextDirectionality)

/**
 *  Inspects the string and makes a best guess at text directionality.
 *
 *  @return the inferred text directionality of this string.
 */
- (JVTextDirection)getBaseDirection;

@end
