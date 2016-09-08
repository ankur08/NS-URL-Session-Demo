//
//  ViewController.m
//  DemoWebServices
//
//  Created by ankur on 23/06/16.
//  Copyright © 2016 ankur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *tabledata;
}

@end

@implementation ViewController

{
    NSMutableArray *finaldata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    finaldata = [[NSMutableArray alloc]init];
    tabledata=[[NSMutableArray alloc]init];

    NSURL *url = [NSURL URLWithString:@"https://data.colorado.gov/resource/4ykn-tg5h.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   // NSError *error ;
   // NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
   
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData *_Nullable data,  NSURLResponse *_Nullable response, NSError *_Nullable error) {
        // failure
        if (error) {
        }
        // TODO: Handle success and
        else{
             tabledata  = [ NSJSONSerialization  JSONObjectWithData:data options:0 error:&error ];
           

            for (int i=0; i<tabledata.count; i++) {
                NSDictionary *insideArry = [tabledata objectAtIndex:i];
                // jitne bhi array address h sab mmain dictionary fill kar dega
                NSDictionary *takeDictionry = [insideArry objectForKey:@"location"];
                NSString *addressGet = [takeDictionry objectForKey:@"human_address"];
                if (addressGet != NULL) {
                    NSError *error ;
                    NSData *data = [addressGet dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *addressDictionary =[NSJSONSerialization  JSONObjectWithData:data options:0 error:&error];
                    [finaldata addObject:addressDictionary];
                }
            }
            
            [self.tableview reloadData];
        }
    }]resume];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [finaldata count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    customCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil)
    {
        cell =(customCell*) [[ UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
   
        NSDictionary *persondetail = [finaldata objectAtIndex:indexPath.row];
        cell.textLabel.text = persondetail[@"city"];
       return cell ;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *persondetail = [finaldata objectAtIndex:indexPath.row];
    UIStoryboard *myStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detail = [myStoryboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.name = persondetail[@"'address"];
    detail.city = persondetail[@"city"];
    detail.state = persondetail[@"state"];
    detail.zip = persondetail[@"zip"];
    
    [self.navigationController pushViewController:detail animated:YES];

}

@end
