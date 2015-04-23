//
//  ViewController.m
//  WeatherSBJson
//
//  Created by MAEDAHAJIME on 2015/04/21.
//  Copyright (c) 2015年 MAEDAHAJIME. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"


@interface ViewController ()
{

}

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    // ① OpenWeatherMap APIのリクエストURLをセット
    NSString *url = @"http://api.openweathermap.org/data/2.5/weather?q=Osaka,jp";
    
    // 天気アイコン取得方法
    // http://openweathermap.org/img/w/"iconの値".png
    
    // ② リクエストURLをUTF8でエンコード
    // ※stringByAddingPercentEscapesUsingEncodingを使うとAPIでよく使われる&はエスケープされません
    NSString *urlEscapeStr = [[NSString  stringWithString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // ③ 通信するためにNSMutableURLRequest型のrequestを作成
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlEscapeStr]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                timeoutInterval:15];
    
    // ④ 通信
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:nil
                                                             error:nil];
    
    // ⑤ ここからSBJsonを利用します。まずはSBJsonを初期化
    SBJsonParser* parser = [[SBJsonParser alloc]init];
    
    // ⑥ JSON形式で来たデータをNSDictionary型に格納
    NSDictionary *result = [parser objectWithData:responseData];
    
    // JSONの中身をLog表示
    NSLog(@"JSON dictionary=%@", [result description]);
    
    
    // ⑦ weather.mainの値を抽出してラベルに表示
    NSArray *main = [result valueForKeyPath:@"weather.main"]; //天候
    NSArray *description = [result valueForKeyPath:@"weather.description"]; // 天候詳細
    NSArray *deg = [result valueForKeyPath:@"wind.deg"]; // 風向き
    NSArray *speed = [result valueForKeyPath:@"wind.speed"]; //風速
    
    //self.label2.text = [result objectForKey:@"wind.speed"]; // 名前
    
    NSLog(@"天候:%@ 天候詳細:%@ 風速:%@ 風向き:%@", main, description, speed, deg);

    //  label1はViewController.xibでセットしたラベルになります。
    NSString *weather01 = main[0];
    NSString *weather02 = description[0];
    
    self.label1.text = [result objectForKey:@"name"]; // 場所
    //self.label2.text = [result objectForKey:@"weather.main"]; // 天候
    self.label2.text = weather01; // 天候
    //self.label3.text = [result objectForKey:@"weather.description"]; // 天候
    self.label3.text = weather02; // 天候詳細
    self.label4.text = [NSString stringWithFormat:@"%@",speed]; //風速
    self.label5.text = [NSString stringWithFormat:@"%@",deg]; // 風向き
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
