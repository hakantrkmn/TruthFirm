//
//  Date+Ext.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 31.08.2024.
//

import Foundation

extension Date{
    func getFormattedDate() -> String
    {
        var format = Date.FormatStyle()
            .day()
            .month()
        return self.formatted(format)
    }
}
