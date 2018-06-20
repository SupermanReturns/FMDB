//
//  CarViewController.m
//  FMDB
//
//  Created by Superman on 2018/6/20.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "CarViewController.h"
#import "DataBase.h"
#import "Person.h"
#import "Car.h"

@interface CarViewController ()
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *carArray;

@end

@implementation CarViewController

#pragma mark - Getter
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)carArray{
    if (!_carArray) {
        _carArray = [[NSMutableArray alloc ] init];
    }
    return _carArray;
}
- (instancetype)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车库";
    
    self.dataArray = [[DataBase sharedDataBase] getAllPerson];
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        Person *person = self.dataArray[i];
        NSMutableArray *carArray =  [[DataBase sharedDataBase] getAllCarsFromPerson:person];
        [self.carArray addObject:carArray];
        
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.dataArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSMutableArray *carArray = self.carArray[section];
    return carArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    Person *person = self.dataArray[section];
    //      NSLog(@"name--%@",person.name);
    label.text = [NSString stringWithFormat:@"%@ 的所有车",person.name];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    //    NSLog(@"label.text--%@",label.text);

    return label;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"carcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableArray *carArray = self.carArray[indexPath.section];
    Car *car = carArray[indexPath.row];
    cell.textLabel.text = car.brand;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"price: $% ld",car.price];
    return cell;
}
/**
 *  设置删除按钮
 *
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        NSMutableArray *carArray = self.carArray[indexPath.section];
        
        Car *car = carArray[indexPath.row];
        
        Person *person = self.dataArray[indexPath.section];
        
        
        NSLog(@"car.id--%@,own_id--%@",car.car_id,car.own_id);
        
        [[DataBase sharedDataBase] deleteCar:car fromPerson:person];
        
        
        self.dataArray = [[DataBase sharedDataBase] getAllPerson];
        
        self.carArray = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < self.dataArray.count; i++) {
            Person *person = self.dataArray[i];
            NSMutableArray *carArray =  [[DataBase sharedDataBase] getAllCarsFromPerson:person];
            [self.carArray addObject:carArray];
            
        }
        
        
        
        [self.tableView reloadData];
        
        
    }
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
