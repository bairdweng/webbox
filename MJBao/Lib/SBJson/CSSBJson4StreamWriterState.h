/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
 
   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
  
   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 
   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@class CSSBSJson4StreamWriter;

@interface CSSBJson4StreamWriterState : NSObject
+ (id)sharedInstance;
- (BOOL)isInvalidState:(CSSBSJson4StreamWriter *)writer;
- (void)appendSeparator:(CSSBSJson4StreamWriter *)writer;
- (BOOL)expectingKey:(CSSBSJson4StreamWriter *)writer;
- (void)transitionState:(CSSBSJson4StreamWriter *)writer;
- (void)appendWhitespace:(CSSBSJson4StreamWriter *)writer;
@end

@interface CSSBJson4StreamWriterStateObjectStart : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateObjectKey : CSSBJson4StreamWriterStateObjectStart
@end

@interface CSSBJson4StreamWriterStateObjectValue : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateArrayStart : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateArrayValue : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateStart : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateComplete : CSSBJson4StreamWriterState
@end

@interface CSSBJson4StreamWriterStateError : CSSBJson4StreamWriterState
@end

