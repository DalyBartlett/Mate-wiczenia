import UIKit
class BasicTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Theme.current.mainColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configureWithItem(item: SlideInModel , indexPath: Int) {
        self.textLabel?.text = item.titles[indexPath]
        self.imageView?.image = UIImage(named: item.picturesName[indexPath])
    }
}
