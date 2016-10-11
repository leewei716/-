//
//  LXSchoolIntroduceController.m
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXSchoolIntroduceController.h"
#import "LXSchllodetailedController.h"
#import "LXSchllodetailedController.h"

#import "UIButton+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface LXSchoolIntroduceController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIWebView *web;

//显示预览图
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *bgView;
@end

@implementation LXSchoolIntroduceController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
   
    UIWebView *web=[[UIWebView alloc]init];
    if (ScreenHeight==480) {
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(280+20+24));
    }else if (ScreenHeight==568){
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(240+20+24));
    }else if (ScreenHeight==667){
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(200+20+24));
    }else{
        web.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(3), FLEXIBLE_NUMX(320), [UIScreen mainScreen].bounds.size.height-FLEXIBLE_NUMY(160+20+24));
    }
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/9d7d246bd350/comments/1518291"]]];
    web.scrollView.delegate=self;
    web.delegate=self;
    _web=web;
    [self.view addSubview:web];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 30, self.view.width-100, 300)];
    self.imageView.alpha = 0.0f;
    self.imageView.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImagePreviewButtonPressed:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:gesture];
    [self.view addSubview:self.imageView];
    

    
    
    [self onLoadButtonPressed:nil];
}

//- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
//    
//    //调整字号
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'";
//    [_web stringByEvaluatingJavaScriptFromString:str];
//    
//    //js方法遍历图片添加点击事件 返回图片个数
//    static  NSString * const jsGetImages =
//    @"function getImages(){\
//    var objs = document.getElementsByTagName(\"img\");\
//    for(var i=0;i<objs.length;i++){\
//    objs[i].onclick=function(){\
//    document.location=\"myweb:imageClick:\"+this.src;\
//    };\
//    };\
//    return objs.length;\
//    };";
//    
//    [_web stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//    
//    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
//    NSString *resurlt = [_web stringByEvaluatingJavaScriptFromString:@"getImages()"];
//    //调用js方法
//    NSLog(@"---调用js方法--%@  %s  jsMehtods_result = %@",self.class,__func__,resurlt);
//}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    //将url转换为string
//    NSString *requestString = [[request URL] absoluteString];
//    //    NSLog(@"requestString is %@",requestString);
//    
//    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
//    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
//        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        //        NSLog(@"image url------%@", imageUrl);
//        
//        if (_bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            _bgView.hidden = NO;
//            _imageView.frame = CGRectMake(10, 10, self.view.width-40, 220);
//            [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:@""];
//        }
//        else
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        
//        return NO;
//    }
//    return YES;
//}
//
//#pragma mark 显示大图片
//-(void)showBigImage:(NSString *)imageUrl{
//    //创建灰色透明背景，使其背后内容不可操作
//    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    [_bgView setBackgroundColor:[UIColor colorWithRed:0.3
//                                               green:0.3
//                                                blue:0.3
//                                               alpha:0.7]];
//    [self.view addSubview:_bgView];
//    
//    //创建边框视图
//    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-20, 240)];
//    //将图层的边框设置为圆脚
//    borderView.layer.cornerRadius = 8;
//    borderView.layer.masksToBounds = YES;
//    //给图层添加一个有色边框
//    borderView.layer.borderWidth = 8;
//    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
//                                                    green:0.9
//                                                     blue:0.9
//                                                    alpha:0.7] CGColor];
//    [borderView setCenter:_bgView.center];
//    [_bgView addSubview:borderView];
//    
//    //创建关闭按钮
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor redColor];
//    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
//    [_bgView addSubview:closeBtn];
//    
//    //创建显示图像视图
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
//    _imageView.userInteractionEnabled = YES;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:@""];
//    [borderView addSubview:_imageView];
//    
//    //添加捏合手势
//    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
//    
//}
//
////关闭按钮
//-(void)removeBigImage
//{
//    _bgView.hidden = YES;
//}
//
//- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
//{
//    //缩放:设置缩放比例
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
//}

- (void)onImagePreviewButtonPressed:(id)sender {

    [UIView animateWithDuration:0.2f animations:^{
        self.imageView.alpha = 0.0f;

    }];
}
- (void)onLoadButtonPressed:(id)sender {
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/9d7d246bd350/comments/1518291"]];
    [self.web reload];
    [self.web loadRequest:req];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//path就是我们点击图片后得到的图片URL，然后你可以在这里做你点击之后要执行的代码
        [self.imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.imageView.alpha = 1.0f;
        }];

        return NO;
    }
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger htmlheight = [[self.web stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];
//    CGFloat documentWidth = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"documentSize = {%f, %f,%ld}", documentWidth, documentHeight,(long)htmlheight);
//    if (_web.scrollView.contentOffset.y>documentHeight && _web.scrollView.tag == 100) {
//        _web.scrollView.scrollEnabled=NO;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"webbottom" object:nil];
//
//        
//    }else if(_web.scrollView.contentOffset.y == 0){
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"webtop" object:nil];
//        
//        _web.scrollView.scrollEnabled=NO;
//    }
//    else if(_web.scrollView.contentOffset.y == 0&&_web.scrollView.tag ==103&&_web.scrollView.contentOffset.y>documentHeight){
//         _web.scrollView.scrollEnabled=NO;
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"ss1" object:nil];
//        
//        
//    }
//    
//
//}


//-(void)webScrollViewScrollEnabled{
////    _web.scrollView.scrollEnabled=YES;
//    CGFloat documentWidth = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//        CGFloat documentHeight = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//        NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
//        if (_web.scrollView.contentOffset.y>documentHeight+350&&_web.scrollView.contentOffset.y==0) {
//            _web.scrollView.scrollEnabled=YES;
//        }
//    NSLog(@"-----------------%f",_web.scrollView.contentOffset.y);
//
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    
//    // 禁用长按弹出框
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)wb
//{
//    //方法1
//    wb=_web;
//    CGFloat documentWidth = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[_web stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
//    if (_web.scrollView.contentOffset.y>documentHeight) {
//        _web.scrollView.scrollEnabled=NO;
//    }
//    方法2
//    _web=wb;
//    CGRect frame = wb.frame;
//    frame.size.width = 768;
//    frame.size.height = 1;
//    //    wb.scrollView.scrollEnabled = NO;
//    wb.frame = frame;
//    
//    frame.size.height = wb.scrollView.contentSize.height;
//    
//    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
//    wb.frame = frame;
//}
//-(UIWebView *)web
//{
//    _web.backgroundColor=[UIColor whiteColor];
//    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.17liuxue.com/unimel/introduce/"]]];
//    [self.view addSubview:_web];
//    if (!_web) {
//        _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,FLEXIBLE_NUMX(320), FLEXIBLE_NUMY(480))];
//        _web.delegate = self;
//        _web.scrollView.delegate = self;
//    }
//    return _web;
//}
//


//下面这行代码是获取web view的实际高度
//NSInteger htmlheight = [[self.showWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] integerValue];


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

///////////////////////////////初始化，self.view是父控件/////////////////////////////////
//_webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0)];
//_webView.delegate = self;
//_webView.scrollView.bounces = NO;
//_webView.scrollView.showsHorizontalScrollIndicator = NO;
//_webView.scrollView.scrollEnabled = NO;
//[_webView sizeToFit];
//
/////////////////////////////////设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串//////////////
//NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlcontent];
//[_webView loadHTMLString:htmlcontent baseURL:nil];
//
//////////////////////////////////delegate的方法重载////////////////////////////////////////////
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //获取页面高度（像素）
//    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    float clientheight = [clientheight_str floatValue];
//    //设置到WebView上
//    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
//    //获取WebView最佳尺寸（点）
//    CGSize frame = [webView sizeThatFits:webView.frame.size];
//    //获取内容实际高度（像素）
//    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
//    float height = [height_str floatValue];
//    //内容实际高度（像素）* 点和像素的比
//    height = height * frame.height / clientheight;
//    //再次设置WebView高度（点）
//    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
//}
//
//
//
//关闭webview回弹效果代码
//[(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];


@end
