//
//  ListCollectionViewController.swift
//  AutmnSchoolRef
//
//  Created by Emil Shpeklord on 11.08.2024.
//

import UIKit

final class ListCollectionViewController: UIViewController {
    
    enum Section: Hashable {
        case main(IconsSectionModel)
    }
    
    enum Item: Hashable {
        case icon(IconModel)
        case description(String)
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias SectionDataSnapshot = NSDiffableDataSourceSectionSnapshot<Item>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
    
    private var dataSource: DataSource!
    private var sections: [IconsSectionModel] = IconsFabric.getModelSections()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
    }
}

private extension ListCollectionViewController {
    
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    func setupDataSource() {
        let cellRegistration = CellRegistration { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            switch item {
            case .icon(let iconModel):
                content.text = iconModel.title
                content.secondaryText = iconModel.subtitle
                content.image = iconModel.image
                if !iconModel.description.isEmpty {
                    var disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
                    disclosureOptions.tintColor = .lightGray
                    cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
                }
            case .description(let description):
                content.text = description
                cell.accessories = []
            }
            cell.contentConfiguration = content
        }
        
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            let section = self.sections[indexPath.section]
            var content = supplementaryView.defaultContentConfiguration()
            content.text = section.title
            supplementaryView.contentConfiguration = content
        }
        
        dataSource = getDataSource(headerRegistration: headerRegistration, cellRegistration: cellRegistration)
        collectionView.dataSource = dataSource
        applyData()
    }
    
    func getDataSource(headerRegistration: HeaderRegistration,
                       cellRegistration: CellRegistration) -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, item -> UICollectionViewListCell in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }
    
    func applyData() {
        var snapshot = DataSnapshot()
        
        for section in sections {
            let sectionIdentifier = Section.main(section)
            snapshot.appendSections([sectionIdentifier])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
        for section in sections {
            let sectionIdentifier = Section.main(section)
            var sectionSnapshot = SectionDataSnapshot()
            
            for icon in section.icons {
                let iconItem = Item.icon(icon)
                sectionSnapshot.append([iconItem])
                if !icon.description.isEmpty {
                    let descriptionItems = icon.description.map { Item.description($0) }
                    sectionSnapshot.append(descriptionItems, to: iconItem)
                }
            }
            
            dataSource.apply(sectionSnapshot, to: sectionIdentifier, animatingDifferences: true)
        }
    }
}

extension ListCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
