//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
@implementation EScrollerView
@synthesize delegate;

#pragma mark - 图片名称与图片描述初始化
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr
{
	if ((self=[super initWithFrame:rect]))
    {
        self.userInteractionEnabled=YES;
        self.tagName = @"酷炫";
        
        //完善前后
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
        
        //添加imageView
		imageArray = [NSArray arrayWithArray:tempArray];
        titleArray = [NSArray arrayWithArray:titArr];
		viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        
        for (int i=0; i<pageCount; i++)
        {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[UIImageView alloc] init];
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用ego异步图片库
                //[imgView setImageWithURL:[NSURL URLWithString:imgURL]];
            }
            else
            {
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];

        
        
        //说明文字层 page
        UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 25,self.bounds.size.width,25)];
        [noteView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7]];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),imgArr.count, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        [noteView addSubview:pageControl];
        
        //说明文字层 noteTag
        tagTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 32, 13)];
        tagTitle.backgroundColor = [UIColor colorWithRed:206.0/255.0 green:16.0/255.0 blue:37.0/255.0 alpha:1.0f];
        tagTitle.text = self.tagName;
        tagTitle.textAlignment = NSTextAlignmentCenter;
        tagTitle.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
        tagTitle.textColor = [UIColor whiteColor];
        [noteView addSubview:tagTitle];
        
        //说明文字层 noteText
        noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(50, 3, self.frame.size.width-pageControlWidth-15, 20)];
        [noteTitle setText:[titleArray objectAtIndex:0]];
        [noteTitle setBackgroundColor:[UIColor clearColor]];
        [noteTitle setFont:[UIFont systemFontOfSize:14]];
        [noteView addSubview:noteTitle];
        
        [self addSubview:noteView];
	}
	return self;
}

#pragma mark - scrollViewDelegate 实现翻页标实
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
       
    pageControl.currentPage=(page-1);
    int titleIndex = page-1;
    if (titleIndex == [titleArray count]) {
        titleIndex = 0;
    }
    if (titleIndex<0) {
        titleIndex = (int)[titleArray count]-1;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0)
    {
      
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1))
    {
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }

}

#pragma mark - 使用delegate去响应按键状态
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

@end
