//
//  TafConstants.swift
//  Run Free
//
//  Created by Jordan Gallivan on 11/26/23.
//

import Foundation
import RegexBuilder

/// Condition Changes for TAFs
public enum TafChanges: String {
    case FM
    case TEMPO
    case PROB
    case BECMG
}

/// Regular expression to match a TAF Condition
let TafQualifierMatcher = Regex {
    Capture(
        ChoiceOf {
            "FM"
            "TEMPO"
            "PROB"
            "BECMG"
        }
    )
    Capture(
        /\d*/
    )
}

let TafForecastWindowMather = Regex {
    Capture{
        /\d{4}/
    }
    "/"
    Capture(
        /\d{4}/
    )
}
