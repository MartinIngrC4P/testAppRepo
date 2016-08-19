//
//  ViewController.m
//  testApp
//
//  Created by Filip Ingr on 19.08.16.
//  Copyright © 2016 Filip Ingr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate> // SCROLL VIEW DELEGATE ! 

@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (strong, nonatomic) UIButton *myNewButton;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;
@property (nonatomic) CGRect screen;
@property (nonatomic) CGFloat sWThird;
@property (strong, nonatomic) NSArray<NSString *> *titlesOfButtons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screen = [UIScreen mainScreen].bounds;
    self.sWThird = self.screen.size.width/3;
    // git ahoj
    
    self.titlesOfButtons = @[@"placeholder", @"Návody", @"Zdraví", @"Něco", @"Hovna", @"Další"];
    
    
    [self postXmlWithXmlString:@""
                      withName:@""
                    withNumber:@""
                withPassportId:@""];
    
    self.firstButton.layer.borderWidth = 1.0f;
    self.firstButton.layer.borderColor = [UIColor redColor].CGColor;
    self.firstButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:220.0/255.0 blue:170.0/255.0 alpha:0.75f];
    
    
    CGRect screen = [UIScreen mainScreen].bounds;
    NSLog(@"width: %f", screen.size.width);
    
    self.myNewButton = [[UIButton alloc] initWithFrame:CGRectMake(screen.size.width/2 - 100, screen.size.height/2 - 40, 200, 80)];
    self.myNewButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.myNewButton];
    
    // tohle je to same co firstButtonAction akorat udělane kodem
    [self.myNewButton addTarget:self action:@selector(newButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupScrollViewWithArrayOfButtons:[self generateButtons:5]];
}


- (void)setupScrollViewWithArrayOfButtons:(NSArray<UIButton *> *)buttonsArray {
    for (UIButton *button in buttonsArray) {
        [self.sliderScrollView addSubview:button];
    }
    
    CGFloat contentSize = buttonsArray.count * self.sWThird + self.sWThird;
    [self.sliderScrollView setContentSize:CGSizeMake(contentSize, 70)];
    
    self.sliderScrollView.showsVerticalScrollIndicator = NO;
    self.sliderScrollView.showsHorizontalScrollIndicator = NO;
}

- (NSArray<UIButton *> *)generateButtons:(NSInteger)numberOfButtons {
    // sWThird je počateční pozice a zaroveň třetina screenu.
    NSMutableArray *buttonsArray = [NSMutableArray new];
    for (int i = 1; i < numberOfButtons; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.sWThird * i, 0, self.sWThird, 70)];
        [button setTitle:self.titlesOfButtons[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonsArray addObject:button];
    }
    
    return buttonsArray;
}

- (void)newButtonAction {
    NSLog(@"tapped new button");
}


- (IBAction)firstButtonActio {
    NSLog(@"tapped");
    [self postXmlWithXmlString:@"" withName:@"" withNumber:@"" withPassportId:@""];
}

- (void)postJson {
    
    __block NSMutableDictionary *resultsDictionary;
    
    NSDictionary *userDictionary = @{@"congressVisitorId" : @"1234567890"};
    
    
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
       
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
       
        NSURL* url = [NSURL URLWithString:@"www.google.com"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];
        
        __block NSError *errorOut = [NSError new];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse* response,NSData* data,NSError* error) {
            
            if ([data length]>0 && error == nil) {
                resultsDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:&errorOut];
                    // je tu něco
            } else if ([data length]==0 && error ==nil) {
                    // bez dat
            } else if( error!=nil) {
                    // fuck
            }
        }];
    }
}

- (void)postXmlWithXmlString:(NSString *)xmlString withName:(NSString *)name withNumber:(NSString *)number withPassportId:(NSString *)passportId {
    
    __block NSMutableDictionary *resultsDictionary;
    
    NSDictionary *userDictionary = @{@"congressVisitorId" : @"1234567890"};
    
   // NSString *xmlString = @"<book id=bk101><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applicationswith XML.</description></book>";
    
    /*
     <book id="bk101">
     <author>Gambardella, Matthew</author>
     <title>XML Developer's Guide</title>
     <genre>Computer</genre>
     <price>44.95</price>
     <publish_date>2000-10-01</publish_date>
     <description>An in-depth look at creating applications
     with XML.</description>
     </book>
     */
    
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {
        
        NSError* error;
        NSData *xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURL* url = [NSURL URLWithString:@"www.google.com"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[xmlData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:xmlData];
        
        __block NSError *errorOut = [NSError new];
        
        
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[[NSOperationQueue alloc] init]
                               completionHandler:^(NSURLResponse *response,NSData *data,NSError *error) {
                                   
                                   if ([data length]>0 && error == nil) {
                                       resultsDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:NSJSONReadingMutableLeaves
                                                                                             error:&errorOut];
                                       // je tu něco
                                   } else if ([data length]==0 && error ==nil) {
                                       // bez dat
                                   } else if( error!=nil) {
                                       // fuck
                                   }
                               }];
    }
}

@end
