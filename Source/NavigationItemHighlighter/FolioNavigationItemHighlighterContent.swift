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
                return "Используйте возможность быстрого перехода к конкретной главе и к Вашим заметкам"
            case .fontOptions:
                return "Настройте удобный Вам режим чтения:"
            }
        }
        
        var description: String? {
            switch self {
            case .chaptersList:
                return nil
            case .fontOptions:
                return "день/ночь (цвет фона), размер и тип шрифта, способ перелистывания страниц (вертикальный или горизонтальный)"
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
