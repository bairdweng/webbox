#import "CSGameProgressView.h"
#import "Masonry.h"
#import "M13ProgressViewPie.h"
#import "M13ProgressViewRing.h"
#import "M13ProgressViewSegmentedRing.h"
#import "M13ProgressViewBar.h"
#import "M13ProgressViewStripedBar.h"
#import "M13ProgressViewSegmentedBar.h"
#import "M13ProgressViewLetterpress.h"
#import "M13ProgressViewRadiative.h"
#import "CSColorManagement.h"
#import "MJConfigModel.h"
@interface CSGameProgressView (){
    NSInteger _typeIndex;
    M13PsrogressView *_progressView;
}
@end
@implementation CSGameProgressView

- (id)initCSGameViewTypeWithIndex:(NSInteger)index{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _typeIndex = index;
        switch (_typeIndex) {
            case 0:{
                [self hx_initPie];
            }
                break;
            case 1:{
                [self hx_initRing];
            }
                break;
            case 2:{
                [self hx_initSegmentedRing];
            } break;
            case 3:{
                [self hx_initBar];
            } break;
            default:{
                [self hx_initPie];
            } break;
        }
    }
    return self;
}
- (void)hx_setProgress:(CGFloat)value{
    if(_progressView.indeterminate == YES){
        [_progressView setIndeterminate:NO];
    }
    [_progressView setProgress:value animated:YES];
    if([_progressView isKindOfClass:[M13ProgressViewRing class]]){
        M13ProgressViewRing* tprogressView = (M13ProgressViewRing*)_progressView;
        if(!tprogressView.showPercentage){
            tprogressView.showPercentage = YES;
        }
    }
    if ([_progressView isKindOfClass:[M13ProgressViewSegmentedRing class]]) {
        M13ProgressViewSegmentedRing *tprogressView = (M13ProgressViewSegmentedRing*)_progressView;
        if (!tprogressView.showPercentage) {
            tprogressView.showPercentage = YES;
        }
    }
    if ([_progressView isKindOfClass:[M13ProgressViewBar class]]) {
        M13ProgressViewBar *tprogressView = (M13ProgressViewBar*)_progressView;
        if (!tprogressView.showPercentage) {
            tprogressView.showPercentage = YES;
        }
    }
}
-(void)hx_initPie{
    M13ProgressViewPie* progressView = [M13ProgressViewPie new];
    progressView.backgroundRingWidth = 5;
    progressView.primaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.secondaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self).offset(-50);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@200);
    }];
    [progressView setNeedsLayout];
    [progressView layoutIfNeeded];
    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(progressView.mas_bottom).equalTo(@15);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = 1;
    
    textLabel.text = [NSString stringWithFormat:@"正在加载[%@]资源包...", [MJConfigModel shared].disPlayName];
    _progressView = progressView;
    [_progressView setIndeterminate:YES];
}
- (void)hx_initRing{
    M13ProgressViewRing* progressView = [M13ProgressViewRing new];
    progressView.primaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.secondaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.showPercentage = NO;
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self).offset(-50);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@200);
    }];
    [progressView setNeedsLayout];
    [progressView layoutIfNeeded];
    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(progressView.mas_bottom).equalTo(@15);
        make.left.right.equalTo(self);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = 1;
    textLabel.text = [NSString stringWithFormat:@"正在加载[%@]资源包...", [MJConfigModel shared].disPlayName];
    _progressView = progressView;
    [_progressView setIndeterminate:YES];
}
-(void)hx_initSegmentedRing{
    M13ProgressViewSegmentedRing* progressView = [[M13ProgressViewSegmentedRing alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    progressView.primaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.secondaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.showPercentage = NO;
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self).offset(-50);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@200);
    }];
    [progressView setNeedsLayout];
    [progressView layoutIfNeeded];
    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(progressView.mas_bottom).equalTo(@15);
        make.left.right.equalTo(self);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = 1;
    textLabel.text = [NSString stringWithFormat:@"正在加载[%@]资源包...", [MJConfigModel shared].disPlayName];
    _progressView = progressView;
    [_progressView setIndeterminate:YES];
}
-(void)hx_initBar{
    M13ProgressViewSegmentedBar* progressView = [[M13ProgressViewSegmentedBar alloc]init];
    progressView.primaryColor = [[CSColorManagement sharedHelper] hx_getMainColor];
    progressView.secondaryColor = [UIColor grayColor];
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self).offset(-50);
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.equalTo(@20);
    }];
    [progressView setNeedsLayout];
    [progressView layoutIfNeeded];
    [progressView layoutSubviews];
    UILabel *textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor whiteColor];
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(progressView.mas_bottom).equalTo(@15);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
    }];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textAlignment = 1;
    textLabel.text = [NSString stringWithFormat:@"正在加载[%@]资源包...", [MJConfigModel shared].disPlayName];
    _progressView = progressView;
    [_progressView setIndeterminate:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

