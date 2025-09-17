//
//  String.swift
//  CoinDex
//
//  Created by Pranav on 18/09/25.
//

import Foundation

extension String {
    /// Remove basic HTML tags and return plain text
    var removingHTMLOccurrences: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        // Try converting HTML to NSAttributedString
        if let attributed = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributed.string
        }
        
        return self
    }
}
