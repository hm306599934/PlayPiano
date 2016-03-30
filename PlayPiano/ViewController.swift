//
//  ViewController.swift
//  PlayPiano
//
//  Created by Jimmy on 28/3/2016.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let screenHieght = UIScreen.mainScreen().bounds.size.height
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    var pianoView = UIView()
    var scoreView = UILabel()
    var score = 0
    
    var blockWidth: CGFloat {
        get{
            return(screenWidth - 3) / 4
        }
    }
    var blockHeight: CGFloat = 80
    var blocks = [AnyObject]()
    var speed:CGFloat = 1
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        let button = UIButton()
        button.frame = CGRectMake((screenWidth - 100) / 2, (screenHieght - 50) / 2, 100, 50)
        button.setTitle("开始", forState: .Normal)
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: #selector(ViewController.play), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    func play(sender: UIButton) {
        sender.removeFromSuperview()
        initPianoView()
        startschedule()
    }
    
    func initPianoView() {
        pianoView.frame = CGRectMake(0, 0, screenWidth, screenHieght)
        self.view.addSubview(pianoView)
        
        scoreView.frame = CGRectMake(30, 50, 100, 50)
        scoreView.textColor = UIColor.redColor()
        scoreView.text = "\(score)"
        scoreView.font = UIFont.systemFontOfSize(30)
        self.view.addSubview(scoreView)
        
        for i in 0...3 {
            let lineView = UIView()
            lineView.frame = CGRectMake(blockWidth * CGFloat(i + 1) + CGFloat(i), 0, 1, screenHieght)
            lineView.backgroundColor = UIColor.blackColor()
            pianoView.addSubview(lineView)
        }
        
        
    }
    
    func getBlockView(index: Int, height: CGFloat) -> UIButton {
        let block = UIButton()
        block.frame = CGRectMake(blockWidth * CGFloat(index) + CGFloat(index), screenHieght, blockWidth, height)
        block.backgroundColor = UIColor.blackColor()
        return block
    }
    
    func startschedule() {
        initBlocks()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(ViewController.moveBlocks), userInfo: nil, repeats: true)
    }
    
    
    func initBlocks() {
        var y: CGFloat = 0
        while y < screenHieght + blockHeight {
            var fourBlock = [UIButton]()
            for i in 0...3 {
                
                let button = UIButton()
                button.frame = CGRectMake(blockWidth * CGFloat(i) + CGFloat(i), y, blockWidth, blockHeight)
                button.backgroundColor = UIColor.whiteColor()
                button.addTarget(self, action: #selector(ViewController.selectBlock), forControlEvents: .TouchUpInside)
                pianoView.addSubview(button)
                fourBlock.append(button)
            }
            blocks.append(fourBlock)
            y = y + blockHeight
        }
        
        blocks.count
    }
    
    func moveBlocks() {
        
        for fourBlock in blocks {
            let index = Int(arc4random() % 4)
            
            for block in fourBlock as! [UIButton] {
                var frame = block.frame
                if frame.origin.y + blockHeight < 0 {
                    frame.origin.y = blockHeight * CGFloat(blocks.count - 1) - 5
                    if block.frame.origin.x == blockWidth * CGFloat(index) + CGFloat(index) {
                        block.backgroundColor = UIColor.blackColor()
                    }else {
                        block.backgroundColor = UIColor.whiteColor()
                    }
                   
                }else {
                    frame.origin.y -= speed
                }
                block.frame = frame
                
                if frame.origin.y + blockHeight < 0 {
                    if block.backgroundColor == UIColor.blackColor() {
                        gameOver()
                    }
                }
            }
        }
    }
//test
    func selectBlock(sender: UIButton) {
        if sender.backgroundColor == UIColor.whiteColor() {
            gameOver()
        }else {
            sender.backgroundColor = UIColor.redColor()
            score += 1
            scoreView.text = "\(score)"
        }
    
    }
    
    func gameOver() {
        timer.invalidate()
        blocks.removeAll()
        pianoView.removeFromSuperview()
        let alertView = UIAlertView(title: "Game Over", message: "您的得分：\(score)", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
        
        initView()
        score = 0
    }
    
}

