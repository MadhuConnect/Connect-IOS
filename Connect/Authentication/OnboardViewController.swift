//
//  OnboardViewController.swift
//  TestVTSAPP
//
//  Created by Venkatesh Botla on 06/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    var myIndex: Int = 0
    
    //data for the slides
    var titles = ["FIRST SCREEN","SECOND SCREEN","THIRTY SCREEN"]
    var descs = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit.","Lorem ipsum dolor sit amet, consectetur adipiscing elit."]
    var imgs = ["corporate","international","teamwork"]
    
    //get dynamic width and height of scrollview and save it
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview
        
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //crete the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            //subviews
            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            imageView.frame = CGRect(x:0,y:0,width:300,height:300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
            
            let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
            txt1.textAlignment = .center
            txt1.font = UIFont.boldSystemFont(ofSize: 20.0)
            txt1.text = titles[index]
            
            let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY+10,width:scrollWidth-64,height:50))
            txt2.textAlignment = .center
            txt2.numberOfLines = 3
            txt2.font = UIFont.systemFont(ofSize: 18.0)
            txt2.text = descs[index]
            
            slide.addSubview(imageView)
            slide.addSubview(txt1)
            slide.addSubview(txt2)
            scrollView.addSubview(slide)
            
        }
        
        //set width of scrollview to accomodate all the slides
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        
        //disable vertical scroll/bounce
        self.scrollView.contentSize.height = 1.0
        
        //initial state
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0

    }

    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    private func loadScreen(_ index: Int) {
        
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
//        switch pageControl.currentPage {
//        case 2:
//            scrollToPage(page: 1, animated: true)
//            pageControl?.currentPage = 1
//            btnNext.setTitle("Next", for: .normal)
//        case 1:
//            scrollToPage(page: 0, animated: true)
//            pageControl?.currentPage = 0
//            btnNext.setTitle("Next", for: .normal)
//        default:
//            btnNext.setTitle("Next", for: .normal)
//            break
//        }
        self.initialRootViewController()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        switch pageControl.currentPage {
        case 0:
            scrollToPage(page: 1, animated: true)
            pageControl?.currentPage = 1
            btnNext.setTitle("Next", for: .normal)
        case 1:
            scrollToPage(page: 2, animated: true)
            pageControl?.currentPage = 2
            btnNext.setTitle("Got it!", for: .normal)
        default:
            btnNext.setTitle("Got it!", for: .normal)
            self.initialRootViewController()
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
    
    private func initialRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
            self.view.window?.rootViewController = rootVC
        }
    }
    
}
