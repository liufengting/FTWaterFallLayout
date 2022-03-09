//
//  ViewController.swift
//  FTWaterFallLayoutDemo
//
//  Created by LiuFengting on 2021/7/6.
//

import UIKit
import FTWaterFallLayout

class ViewController: UIViewController, FTWaterFallLayoutDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var streams: [Streams] = [Streams(name: "", title: "# 重庆体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx3.sinaimg.cn/mw600/007BNb2Vgy1gu85y9x06zj61hc0u0qbd02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 成都体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx2.sinaimg.cn/mw600/006jfzUNgy1gu7ukhhabcj30u00miq92.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 成都体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://tva4.sinaimg.cn/mw600/003qw3Lily1gu8j194botj60u0190mzp02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 重庆体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx1.sinaimg.cn/mw600/003s6xjRgy1gu7vdupj3lj618f1mjkjl02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 重庆体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx3.sinaimg.cn/mw600/007BNb2Vgy1gu85y9x06zj61hc0u0qbd02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 成都体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx2.sinaimg.cn/mw600/006jfzUNgy1gu7ukhhabcj30u00miq92.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 成都体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx4.sinaimg.cn/mw600/002iRMxrly1gu85n2tkplj61900u0wkm02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 重庆体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx1.sinaimg.cn/mw600/002iRMxrly1gu85mwldksj61900u045x02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 重庆体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx4.sinaimg.cn/mw600/002iRMxrly1gu85n2tkplj61900u0wkm02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test"),
                              Streams(name: "", title: "# 成都体育馆", content: "27500平方米，篮排球训练馆、乒乓球馆、健美操馆、武术馆...", contentImageURL: "https://wx4.sinaimg.cn/mw600/002iRMxrly1gu85m7poryj618z0u0aoy02.jpg", stream_url: "rtmp://testlive.aqueti.cn/live/test")]

    let lineSpacing: CGFloat = 10
//    lazy var cellWidth: CGFloat = {(screenWidth-lineSpacing*3)/2}()
    
    lazy var collectionViewLayout : FTWaterFallLayout = {
        let layout = FTWaterFallLayout()
        layout.sectionInset = UIEdgeInsets(top: lineSpacing, left: lineSpacing, bottom: lineSpacing, right: lineSpacing)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = lineSpacing
        layout.delegate = self
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "sd"

        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.register(UINib(nibName: "VideoCell", bundle: Bundle.main), forCellWithReuseIdentifier: "VideoCell")
    }
    
    // MARK: - FTWaterFallLayoutDelegate -
        
    func collectionViewLayout(for section: Int) -> FTWaterFallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .equal)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: FTWaterFallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return FTWaterFallLayout.ft_automaticSize
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: VideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.setupWith(stream: streams[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
