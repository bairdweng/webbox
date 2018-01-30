//
//  MASConstraint.m
//  Masonry
//
//  Created by Nick Tymchenko on 1/20/14.
//

#import "MASConsstraint.h"
#import "MASConstraint+Private.h"

#define MASMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation MASConsstraint

#pragma mark - Init

- (id)init {
	NSAssert(![self isMemberOfClass:[MASConsstraint class]], @"MASConstraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}

#pragma mark - NSLayoutRelation proxies

- (MASConsstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MASConsstraint * (^)(id))mas_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MASConsstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (MASConsstraint * (^)(id))mas_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (MASConsstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (MASConsstraint * (^)(id))mas_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

#pragma mark - MASLayoutPriority proxies

- (MASConsstraint * (^)())priorityLow {
    return ^id{
        self.priority(MASLayoutPriorityDefaultLow);
        return self;
    };
}

- (MASConsstraint * (^)())priorityMedium {
    return ^id{
        self.priority(MASLayoutPriorityDefaultMedium);
        return self;
    };
}

- (MASConsstraint * (^)())priorityHigh {
    return ^id{
        self.priority(MASLayoutPriorityDefaultHigh);
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant proxies

- (MASConsstraint * (^)(MASEdgeInsets))insets {
    return ^id(MASEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (MASConsstraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (MASConsstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (MASConsstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (MASConsstraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}

- (MASConsstraint * (^)(id offset))mas_offset {
    // Will never be called due to macro
    return nil;
}

#pragma mark - NSLayoutConstraint constant setter

- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(MASEdgeInsets)) == 0) {
        MASEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

#pragma mark - Semantic properties

- (MASConsstraint *)with {
    return self;
}

- (MASConsstraint *)and {
    return self;
}

#pragma mark - Chaining

- (MASConsstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    MASMethodNotImplemented();
}

- (MASConsstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (MASConsstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (MASConsstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (MASConsstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (MASConsstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (MASConsstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (MASConsstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (MASConsstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (MASConsstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (MASConsstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (MASConsstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (MASConsstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (MASConsstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (MASConsstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MASConsstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (MASConsstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (MASConsstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MASConsstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MASConsstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MASConsstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MASConsstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - Abstract

- (MASConsstraint * (^)(CGFloat multiplier))multipliedBy { MASMethodNotImplemented(); }

- (MASConsstraint * (^)(CGFloat divider))dividedBy { MASMethodNotImplemented(); }

- (MASConsstraint * (^)(MASLayoutPriority priority))priority { MASMethodNotImplemented(); }

- (MASConsstraint * (^)(id, NSLayoutRelation))equalToWithRelation { MASMethodNotImplemented(); }

- (MASConsstraint * (^)(id key))key { MASMethodNotImplemented(); }

- (void)setInsets:(MASEdgeInsets __unused)insets { MASMethodNotImplemented(); }

- (void)setSizeOffset:(CGSize __unused)sizeOffset { MASMethodNotImplemented(); }

- (void)setCenterOffset:(CGPoint __unused)centerOffset { MASMethodNotImplemented(); }

- (void)setOffset:(CGFloat __unused)offset { MASMethodNotImplemented(); }

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (MASConstraint *)animator { MASMethodNotImplemented(); }

#endif

- (void)activate { MASMethodNotImplemented(); }

- (void)deactivate { MASMethodNotImplemented(); }

- (void)install { MASMethodNotImplemented(); }

- (void)uninstall { MASMethodNotImplemented(); }

@end
