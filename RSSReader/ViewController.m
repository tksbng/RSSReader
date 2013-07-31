//
//  ViewController.m
//  RSSReader
//
//  Created by Takeshi Bingo on 2013/07/31.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    //メンバー変数
    //XMLオブジェクト
    TBXML *rssXML;
    
    //最新ニュースを格納する配列
    NSMutableArray *elementList;
    // Table Viewインスタンス
    IBOutlet UITableView *table;
    //Safariに渡すURL
    NSURL *urlForSafari;
}
//HTTP通信を利用してXMLを取得
-(void)getXML {
    NSString *urlString = @"http://rss.dailynews.yahoo.co.jp/fc/rss.xml";
    NSURL *url = [NSURL URLWithString:urlString];
//成功時のコールバック処理
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmDocument) {
        NSLog(@"「%@」の取得に成功しました。",url);
        //XMLを解析
        [self parseXML];
    };
//失敗時のコールバック処理
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmDocument,NSError *error) {
        NSLog(@"「%@」の取得に成功しました。",url);
    };
    //ステータスバーのActivity Indicatorを起動
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //URLで指定したRSSのXMLをバックグラウンドでダウンロード
    rssXML = [TBXML tbxmlWithURL:url success:successBlock failure:failureBlock];
}

//取得したXMLをパース
-(void)parseXML{
    //elementListを初期化
    elementList = [[NSMutableArray alloc] init];
    //XMLの最初の要素<rss>　を取得
    TBXMLElement *rssElement =rssXML.rootXMLElement;
    
    //<rss>以下の<channel>を取得
    TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rssElement];
    
    //<item>を取得
    TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
    
    //<item>の数だけ繰り返し
    while (itemElement) {
        //<item>以下の<title>を取得
        TBXMLElement *titleElement = [TBXML childElementNamed:@"title" parentElement:itemElement];
        //<item> -> <link>を取得
        TBXMLElement *urlElement = [TBXML childElementNamed:@"link" parentElement:itemElement];
        //<item> -> <pubDate>を取得
        TBXMLElement *dateElement = [TBXML childElementNamed:@"pubDate" parentElement:itemElement];
        
        //それぞれの要素のテキスト内容をNSStringとして取得
        NSString *title = [TBXML textForElement:titleElement];
        NSString *url = [TBXML textForElement:urlElement];
        NSString *date = [TBXML textForElement:dateElement];
        
        NSLog(@"%@ %@",title,url);
        
        //新しいNewsクラスのインスタンス生成
        News *n = [[News alloc] init];
        
        //nにタイトル、URL,日時を格納
        n.title = title;
        n.url = url;
        n.date = date;
        
        //nをelementListに追加
        [elementList addObject:n];
        
        //次の<item>要素に移動
        itemElement = itemElement->nextSibling;
    }
    //バックグラウンドでの処理完了に伴い、フロント側でリストを更新
    [self refreshTableOnFront];
    
//Table viewのセクション数を指定
-(NSInteger)numberOfSectionsTableView:(UITableView *)tableView {
        return  1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
