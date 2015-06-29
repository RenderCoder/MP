//
//  ViewController.swift
//  MP
//
//  Created by JGTM on 15/6/1.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITabBarDelegate , PlayerViewProtocol
{
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet var mainNavigationBar: UINavigationBar!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var audioTag: UILabel!
    @IBOutlet var audioName: UILabel!
    
    
    //model，初始化此viewController或需要刷新view时传入（一般由AppDelegate传入），然后执行刷新view动作
    var model : playInformationProtocol!
    var delegate : protocol<loveActionProtocol,sceneProtocol,playerDelegate>!
    /*
    var model : Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    {
        didSet
        {
            refreshView()
        }
    }
    */
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        initView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        refreshView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func _refreshNavigationBar (#navigationBar : UINavigationBar?) -> Void
    {
        if navigationBar == nil {return}
        
        navigationBar!.translucent = true
        navigationBar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        navigationBar!.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        navigationBar!.shadowImage = UIImage()

    }

    func _refreshTabBar (#tabbar : UITabBar?, scenelist : Array<String> , currentScene : String) -> Void
    {
        if self.tabBar == nil {return}
        
        var currentSceneTag : Int = 0
        
        var tabbarItemsCache : [UITabBarItem] = []
        
        for var i=0; i<scenelist.count; i++
        {
            let sceneItemKeyString : String = scenelist[i]
            let sceneItemNameString : String = scenelist[i]
            
            if sceneItemKeyString == currentScene
            {
                currentSceneTag = i
            }
            
            let item = UITabBarItem(title: sceneItemNameString, image: UIImage(named: "Mode-\(sceneItemKeyString)"), tag: i)
            
            tabbarItemsCache.append(item)
        }
        
        tabbar!.setItems(tabbarItemsCache, animated: true)
        
        for barItem in tabbar!.items as! [UITabBarItem]
        {
            if barItem.tag == currentSceneTag
            {
                tabbar!.selectedItem = barItem
                break
            }
        }
        
    }
    
    private func _refreshBackgroundImageView (#view : UIImageView?) -> Void
    {
        if view == nil {return}
        
        let resourceURL : NSURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent("resource/image", isDirectory: true)
      
        let sceneKey : String = model.scene
        
        let imagePath : NSURL = resourceURL.URLByAppendingPathComponent("\(sceneKey).jpg")

        view!.image = UIImage(contentsOfFile: imagePath.relativePath!)
    }
    
    func _updateTitle () -> Void
    {
        if self.navigationBarTitle == nil {return}

        let sceneName : String = model.scene
        
        navigationBarTitle.title = "\(sceneName)磨耳朵"
    }
    
    @IBAction func togglePlayPause(sender: AnyObject)
    {
      delegate.togglePlayOrPause()
    }
    
    func _refreshPlayPauseButtonView (#button : UIButton?  , playing : Bool) -> Void
    {
        if button == nil {return}
        
        var playPauseButtonImageName : String = "playButton"
        
        if playing
        {
            playPauseButtonImageName = "pauseButton"
        }
      
      button!.setImage(UIImage(named: playPauseButtonImageName), forState: UIControlState.Normal)
      button!.setImage(UIImage(named: "\(playPauseButtonImageName)_active"), forState: UIControlState.Highlighted)
      button!.setImage(UIImage(named: "\(playPauseButtonImageName)_active"), forState: UIControlState.Selected)
    }
    
    //用户点击tabBar切换场景
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!)
    {
        let selectedTabBarItem : UITabBarItem = item as UITabBarItem
        
        let selectedItemTag : Int = selectedTabBarItem.tag
        
        selectedTabBar(tag : selectedItemTag)
        
    }
    
    func selectedTabBar (#tag : Int) -> Void
    {
        let scene : String = model.scenelist[tag]
        
        delegate.switchScene(scene)
    }
    
    func _refreshAudioInfoView (#name : String , tag : String ) -> Void
    {
        if audioName == nil || audioTag == nil {return}
        
        audioName.text = name
        audioTag.text = tag
    }
    
    func initView ()
    {
        refreshView()
        
        _refreshTabBar(tabbar: tabBar, scenelist: model.scenelist, currentScene: model.scene)
    }
    
    
    func refreshView ()
    {
        _refreshNavigationBar(navigationBar: mainNavigationBar)
        
        _updateTitle()

        _refreshPlayPauseButtonView(button: self.playPauseButton, playing: model.playing)
        
        _refreshAudioInfoView(name: model.audioName, tag: model.tag)

        _refreshBackgroundImageView(view: self.backgroundImageView)

    }
    
    //设定status bar 颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    //用户点击「孩子不喜欢」按钮
    @IBAction func tapDislikeButton(sender: AnyObject) {
        delegate.doLike()
    }
    
    @IBAction func tapLikeButton(sender: AnyObject) {
        delegate.doDislike()
    }
    
}

