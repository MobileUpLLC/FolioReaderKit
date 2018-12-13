//
//  NavigationItemContent.swift
//  SberbankVS
//
//  Created by Dmitry Rozov on 11/07/2018.
//  Copyright © 2018 Mobile Up. All rights reserved.
//

import UIKit

internal struct FolioNavigationItemHighlighterContent {
    let data: ContentData
    let item: UIBarButtonItem
    let side: BarButtonItemSide
    
    var itemRect: CGRect? {
        if let view = (item.value(forKey: "view") as? UIView)?.subviews.first {
            return view.superview?.convert(view.frame, to: nil)
        }
        return nil
    }
    
    enum ContentData {
        case chaptersList
        case fontOptions
        
        var title: String {
            switch self {
            case .chaptersList:
                return "Используйте содержание"
            case .fontOptions:
                return "Настройте шрифт"
            }
        }
        
        var description: String? {
            switch self {
            case .chaptersList:
                return "для перехода к нужной главе или Вашим заметкам"
            case .fontOptions:
                return "и другие параметры чтения"
            }
        }
    }
    
    enum BarButtonItemSide {
        case right, left
    }
}

var isNavigationItemHighlightShown: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "navigationItemHighlightShown")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "navigationItemHighlightShown")
    }
}
