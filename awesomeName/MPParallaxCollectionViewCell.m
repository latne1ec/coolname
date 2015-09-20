//
//  MPParallaxCollectionViewCell.m
//  MPPercentDriven
//
//  Created by Alex Manzella on 27/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPParallaxCollectionViewCell.h"

@implementation MPParallaxCollectionViewCell

BOOL theBool;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat w;
        CGFloat h;
        w = self.frame.size.width;
        h = self.frame.size.height;
        
        ///IMAGE
        self.clipsToBounds=YES;
        self.imageView=[[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -MAX_HORIZONTAL_PARALLAX, 0)];
        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds=YES;
        self.imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.imageView];

        ///FADE
        UIImage *fade = [UIImage imageNamed:@"TableCellFade.png"];
        UIImageView *fadeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.fadeViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.fadeViewTwo.image = fade;
        fadeView.image = fade;
        [fadeView setAlpha:1.0];
        [self.fadeViewTwo setAlpha:0.345];
        fadeView.tag = 3737;
        [self addSubview:fadeView];
        [self addSubview:self.fadeViewTwo];
        
        ///BLURVIEW
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self.blurView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.blurView.tag = 8888;
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame:self.frame];
        [self.blurView.contentView addSubview:vibrancyEffectView];
        [self addSubview:self.blurView];
        [self.blurView setAlpha:.26];
        
        //BLACK-VIEW
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.0;
        self.blackView.tag = 3636;
        [self addSubview:self.blackView];

        
        ///SCROLLVIEW
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //[self.scrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height+300)];
        [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height*2)];
        self.scrollView.delegate = self;
        self.scrollView.delaysContentTouches = YES;
        //self.scrollView.directionalLockEnabled = NO;
        self.scrollView.bounces = YES;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.tag = 3939;
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.contentSize.height);
        [self.scrollView setScrollsToTop:YES];
        [self.scrollView setCanCancelContentTouches:YES];
        
        //[self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height)];  ///ADDED THIS
        
        self.scrollView.pagingEnabled = YES;
        
        [self addSubview:self.scrollView];
    
        ///WEBVIEW
//        NSString *source = @"document.body.style.background = \"#777\";";
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        WKUserContentController *controller = [[WKUserContentController alloc] init];
//        config.userContentController = controller;
//        WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        [controller addUserScript:script];
        
        self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, h, w, h) /*configuration:config*/];  ///MADE THIS * 2
        
        self.webview.backgroundColor = [UIColor whiteColor];
        self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.webview.navigationDelegate = self;
        self.webview.scrollView.bounces = YES;
        self.webview.tag = 6969;
        [self.scrollView addSubview:self.webview];
        self.request = [[NSURLRequest alloc] init];
        [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        

        
        self.brokenLinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2*2, 100, 100)];
        self.brokenLinkLabel.textColor = [UIColor whiteColor];
        self.brokenLinkLabel.textAlignment = NSTextAlignmentCenter;
        self.brokenLinkLabel.text = @"Techcrunch";
        //[self.scrollView addSubview:self.brokenLinkLabel];

        
        ///TITLE
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.frame.size.height/2+58, self.frame.size.width-54, 120)];
        if ([UIScreen mainScreen].bounds.size.height <= 568.0 )/*iPhone 4 or 5*/ {
            self.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:22.75];
        } else {
            self.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:28];
        }
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 0;
        //self.titleLabel.adjustsFontSizeToFitWidth = YES;
        //[self.titleLabel setMinimumScaleFactor:10];
        self.titleLabel.tag = 3838;
        self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.titleLabel.layer.shadowOpacity = 0.14;
        self.titleLabel.layer.shadowRadius = 0.25;
        self.titleLabel.layer.shadowOffset = CGSizeMake(.25f, .25f);
        [self.scrollView addSubview:self.titleLabel];
        [self.scrollView bringSubviewToFront:self.titleLabel];
        
        ///TEASER
        self.teaserLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.frame.size.width-46, 80)];

        if ([UIScreen mainScreen].bounds.size.height <= 568.0 ) {
            self.teaserLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:15.5];
        } else {
            self.teaserLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:16.44];
        }
        self.teaserLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.80];
        self.teaserLabel.numberOfLines = 5;
        self.teaserLabel.tag = 5555;
        self.teaserLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.teaserLabel.layer.shadowOpacity = 0.12;
        self.teaserLabel.layer.shadowRadius = 0.20;
        self.teaserLabel.layer.shadowOffset = CGSizeMake(.20f, .20f);
        [self.teaserLabel setAlpha:0.6];
        [self.scrollView addSubview:self.teaserLabel];
        [self.scrollView bringSubviewToFront:self.teaserLabel];
        

        ///BOTTOM FADE
        self.bottomFade = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-60, self.frame.size.width, 140)];
        self.bottomFade.image = [UIImage imageNamed:@"fadeTwo"];
        self.bottomFade.alpha = 0.0;
        [self addSubview:self.bottomFade];
        
        ///SOURCE & TIME AGO
        self.sourceTimeAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.teaserLabel.center.y-86, self.frame.size.width-46, 82)];
        if ([UIScreen mainScreen].bounds.size.height <= 568.0 ) {
            self.sourceTimeAgoLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:12.5];
        } else {
            self.sourceTimeAgoLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:14.2];
        }
        self.sourceTimeAgoLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.794];
        self.sourceTimeAgoLabel.numberOfLines = 5;
        self.sourceTimeAgoLabel.tag = 555511;
        self.sourceTimeAgoLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.sourceTimeAgoLabel.layer.shadowOpacity = 0.12;
        self.sourceTimeAgoLabel.layer.shadowRadius = 0.20;
        self.sourceTimeAgoLabel.layer.shadowOffset = CGSizeMake(.20f, .20f);
        [self.scrollView addSubview:self.sourceTimeAgoLabel];
        [self.sourceTimeAgoLabel setAlpha:0.0];
        [self.scrollView bringSubviewToFront:self.sourceTimeAgoLabel];
        
        ///PROGRESS BAR
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(-1, 0, self.frame.size.width+1, 4.64)];
        self.progressView.trackTintColor = [UIColor lightTextColor];
        [self.webview addSubview:self.progressView];
        
        ///SWIPE UP BUTTON
        self.swipeUpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-19, self.frame.size.height-54, 38, 38)];
        [self.swipeUpButton setBackgroundImage:[UIImage imageNamed:@"swipeUp"] forState:UIControlStateNormal];
        [self.swipeUpButton addTarget:self action:@selector(swipeUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.swipeUpButton setAlpha:0.28];
        self.swipeUpButton.tag = 1060;
        self.swipeUpButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.swipeUpButton.layer.shadowOpacity = 0.64;
        self.swipeUpButton.layer.shadowRadius = 0.36;
        self.swipeUpButton.layer.shadowOffset = CGSizeMake(.36f, .36f);
        [self.scrollView addSubview:self.swipeUpButton];
        [self buttonBounce];
        
        
        ///SWIPE DOWN BUTTON
        self.swipeDownButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-19, 28, 38, 38)];
        [self.swipeDownButton setBackgroundImage:[UIImage imageNamed:@"swipeDown"] forState:UIControlStateNormal];
        [self.swipeDownButton setAlpha:0.84];
        self.swipeDownButton.tag = 1070;
        self.swipeDownButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.swipeDownButton.layer.shadowOpacity = 0.64;
        self.swipeDownButton.layer.shadowRadius = 0.36;
        self.swipeDownButton.layer.shadowOffset = CGSizeMake(.36f, .36f);
        [self.swipeDownButton addTarget:self action:@selector(swipeDownButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.swipeDownButton];
        
        
        ///NEW STORIES COUNT
        self.storyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 108, 100, 60)];
        self.storyCountLabel.textColor = [UIColor whiteColor];
        self.storyCountLabel.textAlignment = NSTextAlignmentCenter;
        self.storyCountLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.4];
        self.storyCountLabel.alpha = 0.44;
        //[self.scrollView addSubview:self.storyCountLabel];
        
        self.clearView = [[UIView alloc] initWithFrame:CGRectMake(0, -260, self.frame.size.width, 260)];
        self.clearView.backgroundColor = [UIColor clearColor];
        [self.clearView setUserInteractionEnabled:YES];
        [self.scrollView addSubview:self.clearView];
        
        self.homeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-90, 196, 180, 40)];
        [self.homeButton setTitle:@"submit link" forState:UIControlStateNormal];
        self.homeButton.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.8];
        CALayer *btn1 = [self.homeButton layer];
        [btn1 setMasksToBounds:YES];
        [btn1 setCornerRadius:19.5f];
        [btn1 setBorderWidth:1.0f];
        [btn1 setBorderColor:[UIColor whiteColor].CGColor];
        [self.homeButton setAlpha:0.74];
        [self.clearView addSubview:self.homeButton];
        
//        
//        self.addPostButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-90, self.homeButton.frame.origin.y+self.homeButton.frame.size.height+26, 180, 40)];
//        [self.addPostButton setTitle:@"add post" forState:UIControlStateNormal];
//        self.addPostButton.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.8];
//        CALayer *btn2 = [self.addPostButton layer];
//        [btn2 setMasksToBounds:YES];
//        [btn2 setCornerRadius:19.5f];
//        [btn2 setBorderWidth:1.0f];
//        [btn2 setBorderColor:[UIColor whiteColor].CGColor];
//        [self.addPostButton setAlpha:0.74];
//        [self.clearView addSubview:self.addPostButton];
        
        
        self.tappableView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, self.frame.size.height-200)];
        self.tappableView.backgroundColor = [UIColor clearColor];
        //[self.scrollView addSubview:self.tappableView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(18, 58, 140, 40)];
        self.title.text = @"baller";
        self.title.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:24.8];
        self.title.textColor = [UIColor whiteColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self.title setAlpha:0.87];
        self.title.tag = 338;
        //[self.scrollView addSubview:self.title];
        
        self.titleTwo = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-70, 64, 140, 40)];
        self.titleTwo.text = @"84 new stories";
        self.titleTwo.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.8];
        self.titleTwo.textColor = [UIColor whiteColor];
        self.titleTwo.textAlignment = NSTextAlignmentCenter;
        [self.titleTwo setAlpha:0.67];
        self.titleTwo.tag = 228;
        //[self.scrollView addSubview:self.titleTwo];
        
        
    }
    return self;
}

-(void)swipeDownButtonTapped {
    
    [self.scrollView setContentOffset:CGPointMake(0, -120) animated:YES];
}

-(void)buttonBounce {
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2.2;
    animationGroup.repeatCount = INFINITY;
    
    CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    pulseAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.125, 1.125, 1.0)];
    pulseAnimation.duration = .095;
    pulseAnimation.timingFunction = easeOut;
    pulseAnimation.autoreverses = YES;
    animationGroup.animations = @[pulseAnimation];
    [self.swipeUpButton.layer addAnimation:animationGroup forKey:@"animateTranslation"];
}

-(void)swipeUpButtonTapped:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height) animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webview) {
        _progress = self.webview.estimatedProgress;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)updateWithContent:(NSURL *)url {
    
    if (url == nil) {
        NSLog(@"Show error");
    }
    self.request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:self.request];
    
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.progressView.alpha = 1.0;
    self.progressView.progress = 0;
    [self.progressView setProgress:_progress animated:YES];
    
    theBool = false;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    theBool = true;
}

-(void)timerCallback {
    
    [self.progressView setProgress:_progress animated:YES];
    
    if (theBool) {
        
        if (self.webview.estimatedProgress >= 1) {
            [self.myTimer invalidate];
            [UIView animateWithDuration:0.14 animations:^{
                
                self.progressView.alpha = 0.0;
                
            }];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //NSLog(@"Scroll: %f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > self.frame.size.height/6) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    if (scrollView.contentOffset.y < 0) {
        
        float blurAlpha = scrollView.contentOffset.y / 200.0f;
        float blackAlpha = scrollView.contentOffset.y / 280.0f;
        float titleAlpha = scrollView.contentOffset.y * 0.00368f;
        if (-blackAlpha >= .7) {
            return;
        }
        [self.blurView setAlpha:-blurAlpha+0.26];
        [self.blackView setAlpha:-blackAlpha];
        [self.titleLabel setAlpha:1+titleAlpha];
        [self.teaserLabel setAlpha:1+titleAlpha];
    }
    
    if (scrollView.contentOffset.y > 0) {
        float blurAlpha = scrollView.contentOffset.y / 300.0f;
        float blackAlpha = scrollView.contentOffset.y / 480.0f;
        float contentAlpha = scrollView.contentOffset.y / 300.0f;
        [self.contentLabel setAlpha:contentAlpha];
        //[self.sourceTimeAgoLabel setAlpha:contentAlpha/2];
        [self.bottomFade setAlpha:contentAlpha];
        if (blackAlpha >= .7) {
            [self bringSubviewToFront:[self.titleLabel superview]];
            [[self.titleLabel superview] bringSubviewToFront:self.titleLabel];
            [self bringSubviewToFront:[self.webview superview]];//**********
            [[self.webview superview] bringSubviewToFront:self.webview];//**********
            
            return;
        }
        self.swipeUpButton.frame = CGRectMake(self.frame.size.width/2-19, self.frame.size.height-54-scrollView.contentOffset.y/14.0, 38, 38);
        self.titleLabel.frame = CGRectMake(18, self.frame.size.height/2-scrollView.contentOffset.y/23.0+44, self.frame.size.width-55, 150);
//        self.teaserLabel.frame = CGRectMake(18, self.titleLabel.center.y+20-scrollView.contentOffset.y/288, self.frame.size.width-46, 80);
        
        [self bringSubviewToFront:[self.titleLabel superview]];
        [[self.titleLabel superview] bringSubviewToFront:self.titleLabel];
        [self.blurView setAlpha:blurAlpha+0.26];
        [self.blackView setAlpha:blackAlpha];
        
        [self bringSubviewToFront:[self.webview superview]];//**********
        [[self.webview superview] bringSubviewToFront:self.webview];//**********
        
    }
    if (scrollView.contentOffset.y < 10) {
        [self setTextAlpha];
    }
}

-(void)scrollThatBitch {
    [self.scrollView setContentOffset:CGPointMake(0, self.frame.size.height) animated:YES];
}


-(void)setTextAlpha {
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentLabel setAlpha:0.0];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setParallaxValue:(CGFloat)parallaxValue{
    
    _parallaxValue=parallaxValue;
        
    CGRect frame=self.imageView.frame;
    frame.origin.x=-MAX_HORIZONTAL_PARALLAX + parallaxValue*MAX_HORIZONTAL_PARALLAX;
    self.imageView.frame=frame;
    
    if ([[self delegate] respondsToSelector:@selector(cell:changeParallaxValueTo:)]) {
        [[self delegate] cell:self changeParallaxValueTo:parallaxValue];
    }
}

- (void)dealloc{
    self.delegate=nil;
}

- (UIImage *)image{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image{
    self.imageView.image=image;
}


@end
