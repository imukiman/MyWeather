//
//  PageViewController.swift
//  Weather
//
//  Created by MacOne-YJ4KBJ on 16/06/2022.
//

import UIKit

class PageViewController: UIPageViewController {
    var pages = [UIViewController]()
    var currenPage = 0
    var ViewBottom = UIView()
    var viewBarButton = UIView()
    var gradient = CAGradientLayer()
    var bt_search = UIButton()
    var bt_menu = UIButton()
    var lineV = UIView()
    var viewContent = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        dataSource = self
        delegate = self
        configBackground()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createArrayAnswer()
    }
    
    fileprivate func configBackground(){
        view.addSubview(viewContent)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewContent.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        viewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        viewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        viewContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        gradient.colors = [UIColor.blue1.cgColor,UIColor.blue2.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        viewContent.layer.insertSublayer(gradient, at: 0)
        view.sendSubviewToBack(viewContent)
    }
    
    fileprivate func configUI(){
        view.addSubview(ViewBottom)
        ViewBottom.translatesAutoresizingMaskIntoConstraints = false
        ViewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        ViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        ViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        
        ViewBottom.addSubview(viewBarButton)
        viewBarButton.translatesAutoresizingMaskIntoConstraints = false
        viewBarButton.topAnchor.constraint(equalTo: ViewBottom.topAnchor, constant: 5).isActive = true
        viewBarButton.bottomAnchor.constraint(equalTo: ViewBottom.bottomAnchor, constant: -5).isActive = true
        viewBarButton.trailingAnchor.constraint(equalTo: ViewBottom.trailingAnchor, constant: 0).isActive = true
        viewBarButton.leadingAnchor.constraint(equalTo: ViewBottom.leadingAnchor, constant: 0).isActive = true
        viewBarButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewBarButton.addSubview(bt_menu)
        bt_menu.translatesAutoresizingMaskIntoConstraints = false
        
        bt_menu.leadingAnchor.constraint(equalTo: viewBarButton.leadingAnchor,constant: 16).isActive = true
        bt_menu.topAnchor.constraint(equalTo: viewBarButton.topAnchor,constant: 0).isActive = true
        bt_menu.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt_menu.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt_menu.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        
        viewBarButton.addSubview(bt_search)
        bt_search.translatesAutoresizingMaskIntoConstraints = false
        bt_search.trailingAnchor.constraint(equalTo: viewBarButton.trailingAnchor,constant: -16).isActive = true
        bt_search.topAnchor.constraint(equalTo: viewBarButton.topAnchor,constant: 0).isActive = true
        bt_search.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bt_search.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bt_search.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        bt_search.tintColor = .white
        bt_search.addTarget(self, action: #selector(searchLocation), for: .touchUpInside)
        
        view.addSubview(lineV)
        lineV.translatesAutoresizingMaskIntoConstraints = false
        lineV.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineV.backgroundColor = .white
        lineV.bottomAnchor.constraint(equalTo: ViewBottom.topAnchor, constant: 0).isActive = true
        lineV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        lineV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func createArrayAnswer(){
        pages = []
        let data = DBManage.shareInstance.readData()
        guard data.count != 0 else{
            return
        }
        for i in 0..<data.count{
            let view = ViewController()
            view.my_longitude = data[i].lng
            view.my_latitude = data[i].lat
            view.name_location = data[i].name
            pages.append(view)
        }
        currenPage = UserDefaults.standard.integer(forKey: "pages")
        setViewControllers([pages[currenPage]], direction: .forward, animated: false, completion: nil)
    }
    
    
    @objc func searchLocation(){
        let vc = AllLocationsViewController()
        vc.modalPresentationStyle = .fullScreen
        //vc.delegateSearch = self
        present(vc, animated: true)
    }
  
}


extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            //currenPage = currentIndex
            return nil
            // wrap last return pages.last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        }
        else{
            //currenPage = currentIndex
            return nil
            // wrap first pages.first
        }
    }
}

// MARK: - Delegates

extension PageViewController: UIPageViewControllerDelegate {
    
    
    // How we keep our pageControl in sync with viewControllers
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        if currenPage != currentIndex{
            currenPage = currentIndex
            UserDefaults.standard.set(currenPage, forKey: "pages")
        }
    }
    
    private func animateControlsIfNeeded() {

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}


