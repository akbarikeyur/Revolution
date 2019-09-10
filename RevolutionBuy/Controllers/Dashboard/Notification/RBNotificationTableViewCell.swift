//
//  RBNotificationTableViewCell.swift
//  RevolutionBuy
//
//  Created by Vivek Yadav on 06/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RBNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configueCell(data: RBNotificationDetail?) {

        guard let notificationDetail: RBNotificationDetail = data else {
            return
        }

        if notificationDetail.hasNotificationRead() {
            self.contentView.backgroundColor = Constants.color.notificationReadColor
        } else {
            self.contentView.backgroundColor = Constants.color.notificationUnReadColor
        }

        if let desc = data?.descriptionValue {
            lblNotification.text = desc
        }

        if let timestamp: Int = data?.timestamp {
            lblTime.isHidden = false
            lblTime.text = RelativeTime.calculateRelativeTime(time: timestamp)
        } else {
            lblTime.isHidden = true
        }

    }
}
