//
// CSGTMDefines.h
//
//  Copyright 2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

// ============================================================================

#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_2_1
#define __IPHONE_2_1 20100
#endif
#ifndef __IPHONE_2_2
#define __IPHONE_2_2 20200
#endif
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the CSGTM_CONTAINERS_VALIDATION_FAILED_LOG and
// CSGTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef CSGTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define CSGTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(CSGTM_INLINE)
#if defined (__GNUC__) && (__GNUC__ == 4)
#define CSGTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define CSGTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (CSGTM_EXTERN)
#if defined __cplusplus
#define CSGTM_EXTERN extern "C"
#define CSGTM_EXTERN_C_BEGIN extern "C" {
#define CSGTM_EXTERN_C_END }
#else
#define CSGTM_EXTERN extern
#define CSGTM_EXTERN_C_BEGIN
#define CSGTM_EXTERN_C_END
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (CSGTM_EXPORT)
#define CSGTM_EXPORT __attribute__((visibility("default")))
#endif

// Give ourselves a consistent way of declaring something as unused. This
// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (CSGTM_UNUSED)
#define CSGTM_UNUSED(x) ((void)(x))
#endif

// _CSGTMDevLog & _CSGTMDevAssert
//
// _CSGTMDevLog & _CSGTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.
//
// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.
//
//    _CSGTMDevLog           log some error/problem in debug builds
//    _CSGTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.
//
// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.
//

// We only define the simple macros if nothing else has defined this.
#ifndef _CSGTMDevLog

#ifdef DEBUG
#define _CSGTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _CSGTMDevLog(...) do { } while (0)
#endif

#endif // _CSGTMDevLog

#ifndef _CSGTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _CSGTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _CSGTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _CSGTMDevAssert

// _CSGTMCompileAssert
// _CSGTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _CSGTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _CSGTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _CSGTMCompileAssertSymbolInner(line, msg) _CSGTMCOMPILEASSERT ## line ## __ ## msg
#define _CSGTMCompileAssertSymbol(line, msg) _CSGTMCompileAssertSymbolInner(line, msg)
#define _CSGTMCompileAssert(test, msg) \
typedef char _CSGTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _CSGTMCompileAssert

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the CSGTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of CSGTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define CSGTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define CSGTM_IPHONE_SIMULATOR 1
#else
#define CSGTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
#else
// For MacOS specific stuff
#define CSGTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if CSGTM_MACOS_SDK
#define CSGTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define CSGTM_AVAILABLE_ONLY_ON_MACOS
#else
#define CSGTM_AVAILABLE_ONLY_ON_IPHONE
#define CSGTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef CSGTM_SUPPORT_GC
#if CSGTM_IPHONE_SDK
// iPhone never needs GC
#define CSGTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define CSGTM_SUPPORT_GC 0
#else
#define CSGTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

// Some support for advanced clang static analysis functionality
// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif

#ifndef CSGTM_NONNULL
#define CSGTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

#ifdef __OBJC__

// Declared here so that it can easily be used for logging tracking if
// necessary. See CSGTMUnitTestDevLog.h for details.
@class NSString;
CSGTM_EXTERN void _CSGTMUnitTestDevLog(NSString *format, ...);

// Macro to allow you to create NSStrings out of other macros.
// #define FOO foo
// NSString *fooString = CSGTM_NSSTRINGIFY(FOO);
#if !defined (CSGTM_NSSTRINGIFY)
#define CSGTM_NSSTRINGIFY_INNER(x) @#x
#define CSGTM_NSSTRINGIFY(x) CSGTM_NSSTRINGIFY_INNER(x)
#endif

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef CSGTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define CSGTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define CSGTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define CSGTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define CSGTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define CSGTM_FOREACH_OBJECT(element, collection) \
CSGTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define CSGTM_FOREACH_KEY(element, collection) \
CSGTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// To simplify support for both Leopard and Snow Leopard we declare
// the Snow Leopard protocols that we need here.
#if !defined(CSGTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
#define CSGTM_10_6_PROTOCOLS_DEFINED 1
@protocol NSConnectionDelegate
@end
@protocol NSAnimationDelegate
@end
@protocol NSImageDelegate
@end
@protocol NSTabViewDelegate
@end
#endif  // !defined(CSGTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

// CSGTM_SEL_STRING is for specifying selector (usually property) names to KVC
// or KVO methods.
// In debug it will generate warnings for undeclared selectors if
// -Wunknown-selector is turned on.
// In release it will have no runtime overhead.
#ifndef CSGTM_SEL_STRING
#ifdef DEBUG
#define CSGTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
#else
#define CSGTM_SEL_STRING(selName) @#selName
#endif  // DEBUG
#endif  // CSGTM_SEL_STRING

#endif // __OBJC__