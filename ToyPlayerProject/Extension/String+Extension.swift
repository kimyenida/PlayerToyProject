//
//  String+Extension.swift
//  ToyPlayerProject
//
//  Created by Admin iMBC on 1/23/24.
//

import Foundation


extension String{
    func applySSL() -> String {
        return self.replacingOccurrences(of: "http:", with: "https:")
    }
}
