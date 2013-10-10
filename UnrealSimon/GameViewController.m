//
//  FirstViewController.m
//  UnrealSimon
//
//  Created by Derek Neil on 2013-10-06.
//  Copyright (c) 2013 DKN Teck. All rights reserved.
//

#import "GameViewController.h"
#import "SoundController.h"

@interface GameViewController ()

- (void)playGameSequence:(NSUInteger)move; //observe [game currentMove]
- (void)pressButton:(UIButton *)button;
- (void)releaseButton:(UIButton *)button;
- (void)badMove; //activated by return from [game checkIsGoodMove]

- (void)successfullSequence; //observe [game correctSequenceSeen]
- (void)encouragementSounds; //observe [game goodSequences]

- (void)updateScore:(NSString *)newScore;
- (void)updateHealth:(NSString *)newHealth;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//     NSLog(@"viewDidLoad ");
    
	// Do any additional setup after loading the view, typically from a nib.
    self.encouragements = [NSMutableArray arrayWithObjects:
                      @"rampage",
                      @"dominating",
                      @"unstoppable",
                      @"godlike",
                      nil];
    
    self.gameInputsEnabled = FALSE;
    
    //initiate an instance of the game
//    self.game = [[Game alloc] init];

}

- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"viewWillAppear ");
    
}

- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"viewWillDisappear ");

}

-(void)setPlayer:(PlayerController *)player{
    //remove any old observers
    if(self.player !=nil){
        //TODO: remove observe player points
        
        //TODO: remove observe player health
    }
    
    //get save new ref to game
    self.player = player;
    
    if(self.game !=nil){
        //TODO: observe player points
        
        //TODO: observe player health
    }
    
}

-(void)setGame:(Game *)game{
    //remove any old observers
    if(self.game != nil){
        [self.game removeObserver:self forKeyPath:@"currentMove"];
        [self.game removeObserver:self forKeyPath:@"goodSequences"];
    //    [self.game removeObserver:self forKeyPath:@"correctSequenceSeen"];
        [self.game removeObserver:self forKeyPath:@"acceptingInput"];
        [self.game removeObserver:self forKeyPath:@"isIdle"];
        [self.game removeObserver:self forKeyPath:@"badMove"];
        [self.game removeObserver:self forKeyPath:@"level"];
    }
    
    //get save new ref to game
    self.game = game;
    
    if(self.game !=nil){
        [self.game addObserver:self forKeyPath:@"currentMove" options:NSKeyValueObservingOptionNew context:NULL];
        [self.game addObserver:self forKeyPath:@"goodSequences" options:NSKeyValueObservingOptionNew context:NULL];
        //    [self.game addObserver:self forKeyPath:@"correctSequenceSeen" options:NSKeyValueObservingOptionNew context:NULL];
        [self.game addObserver:self forKeyPath:@"acceptingInput" options:NSKeyValueObservingOptionNew context:NULL];
        [self.game addObserver:self forKeyPath:@"isIdle" options:NSKeyValueObservingOptionNew context:NULL];
        [self.game addObserver:self forKeyPath:@"badMove" options:NSKeyValueObservingOptionNew context:NULL];
        [self.game addObserver:self forKeyPath:@"level" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
}


- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    
    //debug observers
    NSLog(@"   observer %@ -> %@", keyPath, [change objectForKey:NSKeyValueChangeNewKey]);
    
    //game listeners
    if ([keyPath isEqualToString:@"currentMove"]) {
        NSNumber* _move = [change objectForKey:NSKeyValueChangeNewKey];
        [self playGameSequence:[_move integerValue]];
    }
    else if ([keyPath isEqualToString:@"goodSequences"]) {
        NSNumber* _goodSequences = [change objectForKey:NSKeyValueChangeNewKey];
        NSInteger _goodSequencesInt = [_goodSequences integerValue];
        if( _goodSequences>0){
            if(_goodSequencesInt % 5 == 0){
                [self encouragementSounds];
            }
            else{
                [self successfullSequence];
            }
        }
    }
//    else if ([keyPath isEqualToString:@"correctSequenceSeen"]) {
//        BOOL _done = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
//        if( _done ){
//            [self successfullSequence];
//        }
//    }
    else if ([keyPath isEqualToString:@"level"]) {
        if([[change objectForKey:NSKeyValueChangeNewKey] intValue] == 1){
            [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        }
    }
    else if ([keyPath isEqualToString:@"badMove"]) {
        if([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == TRUE){
            [self badMove];
        }
    }
    else if ([keyPath isEqualToString:@"acceptingInput"]) {
        self.gameInputsEnabled = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    }
    else if ([keyPath isEqualToString:@"isIdle"]) {
        self.playPauseButton.enabled = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        self.playPauseButton.hidden = !self.playPauseButton.enabled;
    }
    
    //player listeners
    else if ([keyPath isEqualToString:@"health"]) {
        NSString* _new = [[change objectForKey:NSKeyValueChangeNewKey] stringValue];
        [self updateHealth:_new];
    }
    else if ([keyPath isEqualToString:@"points"]) {
        NSString* _new = [[change objectForKey:NSKeyValueChangeNewKey] stringValue];
        [self updateScore:_new];
    }
}

-(void)updateHealth:(NSString *)newHealth{
    self.health.text = newHealth;
    
    //TODO: highlight score change
    
}

-(void)updateScore:(NSString *)newScore{
    self.score.text = newScore;
    
    //TODO: highlight health change
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)playPauseAction:(id)sender{

    NSLog(@"playPauseAction -> %@", [sender currentTitle]);
    
    if( [[sender currentTitle ] isEqualToString:@"Play"] ){
        
        //Change Button
        [sender setTitle:@"Quit" forState:UIControlStateNormal];
        
        //play game start sound
        [self.sound play:@"start"];
        
        //pass off to gameController
        [self.game playSequence];
    }
    else if( [[sender currentTitle] isEqualToString:@"Quit"] ){
        //Change Button
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
        
        //play sound
        [self badMove];
        
        //tell game player is quitting
        [self.game abortGame];
    }
    
}

- (IBAction)move:(id)move{
    int moveCode = 0;
    
    if(self.gameInputsEnabled){
        NSLog(@"move -> %@", [move restorationIdentifier]);
        
        //code move for game
        if(move == self.greenButton){
            moveCode=1;
            [self.sound play:@"green"];
        }
        else if ( move == self.redButton ){
            moveCode=2;
            [self.sound play:@"red"];
        }
        else if (move == self.blueButton){
            moveCode=3;
            [self.sound play:@"blue"];
        }
        else if (move == self.yellowButton){
            moveCode=4;
            [self.sound play:@"yellow"];
        }
    }
    else{
        NSLog(@"moveIgnored -> %@", [move restorationIdentifier]);
    }
}

- (void)successfullSequence{
    //TODO: highlight points added
    
     //play success sound
    [self performSelector:@selector(delayPlaySound:)
               withObject:@"armour"
               afterDelay:0.5];
}

- (void)delayPlaySound:(NSString *)soundName{
    [self.sound play:soundName];
}

- (void)encouragementSounds{
    //TODO: highlight points added
    
    //play random encourangement sound
    [self performSelector:@selector(delayPlaySound:)
               withObject:[self.encouragements objectAtIndex:[self.game random:1:3]]
               afterDelay:0.2];
}

- (void)badMove{
    //flash game view background colour with red
    self.redBackground.alpha = 0.5;
    
    [self performSelector:@selector(delayPlaySound:)
               withObject:@"dying"
               afterDelay:0.1];
    
    //Animate to black color over period of two seconds (changeable)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1]; 
    self.redBackground.alpha = 0;
    [UIView commitAnimations];
}


//observe [game currentMove]
//play game sequence to user
- (void)playGameSequence:(NSUInteger)move{
    
    NSLog(@"playGameSequence -> %lu", (unsigned long)move);
    
    if(move==1){ //press green
        [self.sound play:@"green"];
        [self pressButton:self.greenButton];
    }
    else if (move==2){ //press red
        [self.sound play:@"red"];
        [self pressButton:self.redButton];
    }
    else if (move==3){ //press blue
        [self.sound play:@"blue"];
        [self pressButton:self.blueButton];
    }
    else if (move==4){ //press yellow
        [self.sound play:@"yellow"];
        [self pressButton:self.yellowButton];
    }
}

//worker method simulating button pushes
- (void)pressButton:(UIButton *)button{
//    NSLog(@"pressButton -> %@", [button restorationIdentifier]);
    [button sendActionsForControlEvents: UIControlEventTouchUpInside];
    [button setHighlighted:TRUE];
    [self performSelector:@selector(releaseButton:)
               withObject:button
               afterDelay:0.25];
}

//relase simulated button pushes
- (void)releaseButton:(UIButton *)button{
//    NSLog(@"releaseButton -> %@", [button restorationIdentifier]);
    [button setHighlighted:FALSE];
}

@end
