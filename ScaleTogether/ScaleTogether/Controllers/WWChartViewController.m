//
//  WWChartViewController.m
//  ScaleTogether
//
//  Created by Wee Witthawaskul on 2/10/13.
//  Copyright (c) 2013 Wee Witthawaskul. All rights reserved.
//
#define IDENTIFIER_YOURS @"Yours"
#define IDENTIFIER_GROUP @"Group"

#import "WWChartViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "ISO8601DateFormatter.h"

@interface WWChartViewController()<CPTPlotDataSource>

@property (nonatomic) CPTGraphHostingView *hostView;
@property (nonatomic) CPTTheme *selectedTheme;
@property (nonatomic) NSMutableArray *weightHistory;
@property (nonatomic) NSMutableArray *groupWeightHistory;

@end

@implementation WWChartViewController

- (void)awakeFromNib
{
    self.weightHistory = [@[ @[@"2013-02-01T9:05:00Z", @185.0],
                             @[@"2013-02-02T9:05:00Z", @186.0],
                             @[@"2013-02-03T9:05:00Z", @185.5],
                             @[@"2013-02-04T9:05:00Z", @184.0]] mutableCopy];
    
    self.groupWeightHistory = [@[ @[@"2013-02-01T9:05:00Z", @170.0],
                                  @[@"2013-02-02T9:05:00Z", @172.0],
                                  @[@"2013-02-03T9:05:00Z", @186.5],
                                  @[@"2013-02-04T9:05:00Z", @173.0]] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot
{
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureAxes];
}

-(void)configureHost
{
    CGRect parentRect = self.view.bounds;
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph
{
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    NSString *title = @"Weight History";
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configureChart
{
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    CPTScatterPlot *myWeightPlot = [[CPTScatterPlot alloc] init];
    myWeightPlot.dataSource = self;
    myWeightPlot.identifier = IDENTIFIER_YOURS;
    CPTColor *myWeightPlotColor = [CPTColor redColor];
    [graph addPlot:myWeightPlot toPlotSpace:plotSpace];
    CPTScatterPlot *groupWeightPlot = [[CPTScatterPlot alloc] init];
    groupWeightPlot.dataSource = self;
    groupWeightPlot.identifier = IDENTIFIER_GROUP;
    CPTColor *groupWeightColor = [CPTColor greenColor];
    [graph addPlot:groupWeightPlot toPlotSpace:plotSpace];

    [plotSpace scaleToFitPlots:@[myWeightPlot, groupWeightPlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;

    CPTMutableLineStyle *myWeightPlotLineStyle = [myWeightPlot.dataLineStyle mutableCopy];
    myWeightPlotLineStyle.lineWidth = 2.5;
    myWeightPlotLineStyle.lineColor = myWeightPlotColor;
    myWeightPlot.dataLineStyle = myWeightPlotLineStyle;
    CPTMutableLineStyle *myWeightPlotSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    myWeightPlotSymbolLineStyle.lineColor = myWeightPlotColor;
    CPTPlotSymbol *myWeightPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    myWeightPlotSymbol.fill = [CPTFill fillWithColor:myWeightPlotColor];
    myWeightPlotSymbol.lineStyle = myWeightPlotSymbolLineStyle;
    myWeightPlotSymbol.size = CGSizeMake(6.0f, 6.0f);
    myWeightPlot.plotSymbol = myWeightPlotSymbol;
    CPTMutableLineStyle *groupWeightPlotLineStyle = [groupWeightPlot.dataLineStyle mutableCopy];
    groupWeightPlotLineStyle.lineWidth = 1.0;
    groupWeightPlotLineStyle.lineColor = groupWeightColor;
    groupWeightPlot.dataLineStyle = groupWeightPlotLineStyle;
    CPTMutableLineStyle *groupLineStyle = [CPTMutableLineStyle lineStyle];
    groupLineStyle.lineColor = groupWeightColor;
    CPTPlotSymbol *groupWeightSymbol = [CPTPlotSymbol starPlotSymbol];
    groupWeightSymbol.fill = [CPTFill fillWithColor:groupWeightColor];
    groupWeightSymbol.lineStyle = groupLineStyle;
    groupWeightSymbol.size = CGSizeMake(6.0f, 6.0f);
    groupWeightPlot.plotSymbol = groupWeightSymbol;
}

-(void)configureAxes
{
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Day of Month";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = self.weightHistory.count;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (NSArray *dateWeight in self.weightHistory) {
        NSString *date = dateWeight[0];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;

    CPTAxis *y = axisSet.yAxis;
    y.title = @"Weight";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    CGFloat yMax = 700.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    if ([plot.identifier isEqual:IDENTIFIER_YOURS])
        return self.weightHistory.count;
    if ([plot.identifier isEqual:IDENTIFIER_GROUP])
        return self.groupWeightHistory.count;
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSArray *dateWeight = nil;
    if ([plot.identifier isEqual:IDENTIFIER_YOURS]) {
        dateWeight = self.weightHistory[index];
    } else if ([plot.identifier isEqual:IDENTIFIER_GROUP]) {
        dateWeight = self.groupWeightHistory[index];
    } else {
        return nil;
    }
    NSNumber *result;
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
        {
            NSTimeInterval firstDateTime = [[self dateFromUTCString:self.weightHistory[0][0]] timeIntervalSince1970];
            NSDate *dateTime = [self dateFromUTCString:dateWeight[0]];
            NSTimeInterval x =  [dateTime timeIntervalSince1970] - firstDateTime;
            result = [NSNumber numberWithDouble:x];
        }
        break;
        case CPTScatterPlotFieldY:
            result = dateWeight[1];
            break;
        default:
            break;
    }
    return result;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    return nil;
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return @"Weight";
}


#pragma mark - Date & Time
- (NSDate *)dateFromUTCString:(NSString *)stringValue
{
    ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
    return [dateFormatter dateFromString:stringValue];
}

- (NSString *)stringDateTimeFromDate:(NSDate *)date
{
    NSDateFormatter *dateTimeWithTimeZoneFormatter = [[NSDateFormatter alloc] init];
    
    return [dateTimeWithTimeZoneFormatter stringFromDate:date];
}
@end
