//
//  String+Ext.swift
//  TruthFirm
//
//  Created by Hakan Türkmen on 31.08.2024.
//

import Foundation

extension String
{
    func lowercaseRemoveBlank() -> String
    {
        return self.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
