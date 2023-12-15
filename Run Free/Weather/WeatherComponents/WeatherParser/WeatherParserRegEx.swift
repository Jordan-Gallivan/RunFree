//
//  WeatherParserRegEx.swift
//  Run Free
//
//  Created by Jordan Gallivan on 12/14/23.
//

import Foundation
import RegexBuilder

extension ChoiceOf where RegexOutput == Substring {
    init<S: Sequence<String>>(_ components: S) {
        let exps = components.map { AlternationBuilder.buildExpression($0) }
        self = exps.dropFirst().reduce(AlternationBuilder.buildPartialBlock(first: exps[0])) { acc, next in
            AlternationBuilder.buildPartialBlock(accumulated: acc, next: next)
        }
    }
}

enum WeatherParserRegEx {
    static let WEATHER_CONDITIONS = Regex {
        Capture {
            Optionally {
                ChoiceOf {
                    "+"
                    "-"
                }
            }
            ChoiceOf(WeatherConditionConstants.WEATHER_CONDITION_DICTIONARY.keys)
        }
    }
    
    static let WIND = Regex {
        Capture {
            ChoiceOf {
                /\d{5}KT/
                /\d{5}G\d{1,2}KT/
                /VRB\d{2}KT/
                "/////KT"
            }
        }
    }
    
    static let CLOUDS = Regex {
        Capture {
            ChoiceOf(SKY_CONDITIONS)
        }
    }
    
    static let TEMPERATURE = Regex {
        " "
        Capture {
            Optionally {
                "M"
            }
            /\d{2}/
        }
        "/"
    }
}
