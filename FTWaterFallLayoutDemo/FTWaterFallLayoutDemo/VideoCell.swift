//
//  VideoCell.swift
//  Panorama
//
//  Created by LiuFengting on 2021/8/24.
//

import UIKit
import AlamofireImage

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var praiseLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.avatarImageView.layer.cornerRadius = 10
    }
    
    func setupWith(stream: Streams) {
        self.contentLabel.text = stream.content
        if let imageURL = URL(string: stream.contentImageURL) {
            self.contentImageView.af.setImage(withURL: imageURL, completion:  { response in
                
            })
        }
    }

}
