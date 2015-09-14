//
//  MPParallaxCollectionViewCell.h
//  MPPercentDriven
//
//  Created by Alex Manzella on 27/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ProgressHUD.h"

#define MAX_HORIZONTAL_PARALLAX 125

@class MPParallaxCollectionViewCell;

@protocol MPParallaxCellDelegate <NSObject>

@required

- (void)cell:(MPParallaxCollectionViewCell *)cell changeParallaxValueTo:(CGFloat)value;



@end

@interface MPParallaxCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate, UIWebViewDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readwrite) UIView *clearView;

@property (nonatomic, readwrite) WKWebView *webview;
@property (nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic,readwrite) UIImage *image;
@property (nonatomic,readwrite) UIImageView *imageView;
@property (nonatomic, readwrite) UIImageView *fadeViewTwo;
@property (nonatomic, readwrite) UIImageView *bottomFade;
@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) UILabel *sourceTimeAgoLabel;
@property (nonatomic, readwrite) UILabel *teaserLabel;
@property (nonatomic, readwrite) UILabel *contentLabel;
@property (nonatomic, readwrite) UIScrollView *scrollView;
@property (nonatomic, readwrite) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, readwrite) UIButton *homeButton;
@property (nonatomic, readwrite) UIButton *addPostButton;
@property (nonatomic, readwrite) UIButton *readMoreButton;
@property (nonatomic, readwrite) UIButton *shareButton;
@property (nonatomic, readwrite) UIButton *favButton;
@property (nonatomic, readwrite) UIButton *closeButton;
@property (nonatomic, readwrite) UIButton *toolBarshareButton;
@property (nonatomic, readwrite) UIButton *toolBarfavButton;

@property (nonatomic,assign) CGFloat parallaxValue; 
@property (nonatomic,assign) id<MPParallaxCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property (nonatomic, readwrite) NSURL *url;
@property (nonatomic, readwrite) UIProgressView *progressView;
@property (nonatomic, readwrite) NSTimer *myTimer;

@property (nonatomic, readwrite) UILabel *storyCountLabel;
@property (nonatomic, readwrite) UILabel *brokenLinkLabel;
@property (nonatomic) float progress;
@property (nonatomic, readwrite) UIButton *swipeUpButton;
@property (nonatomic, readwrite) UIButton *swipeDownButton;
@property (nonatomic, readwrite) UILabel *homeButtonLabel;

@property (nonatomic, readwrite) UIView *tappableView;
@property (nonatomic, readwrite) UILabel *title;
@property (nonatomic, readwrite) UILabel *titleTwo;




-(void)updateWithContent:(NSURL *)url;



@end
