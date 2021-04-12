//
//  BGMainCell.swift
//  BotanicalGarden
//
//  Created by Wii Lin on 2021/4/12.
//

import UIKit
import Kingfisher
class BGMainCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var featureLabel: UILabel!
    
    //MARK: - override
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.kf.cancelDownloadTask()
        coverImageView.kf.indicatorType = .activity
    }
    // MARK: - Interface
    func configure(botanical: BGBotanical) {
        coverImageView.kf.setImage(with: botanical.imageUrl,
                        options: [.transition(ImageTransition.fade(0.3)), .forceTransition]
        )
        nameLabel.text = botanical.name
        locationLabel.text = botanical.location
        featureLabel.text = botanical.feature
    }
}
