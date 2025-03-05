//
//  AudioPromptsViewController.swift
//  MyTestDemo
//  
//  Created by Bai, Payne on 2024/1/15.
//  Copyright © 2024 Garmin All rights reserved
//  

import UIKit
import AVFAudio

/**
 * Represents a language/region combination supported by the phone
 */
struct AudioPromptsLanguage: CustomStringConvertible {

    /// ISO 639-1: two-character language code (example: en); required
    public let languageCode: String

    /// ISO 3166: two-character country code (example: US); optional
    public let countryCode: String?

    /// Dumps fields in dictionary format
    var description: String {
        return ["Language Code": languageCode,
                "Country Code": countryCode ?? "No Country Code"].description
    }

    /// Initializes required language code and optional country code
    public init(language: String, country: String?) {
        languageCode = language
        countryCode = country
    }

    static public func retrieveAudioPromptsLanguages() -> [AudioPromptsLanguage] {
            var languages: [AudioPromptsLanguage] = []
            let voices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
            for voice in voices {
                let rawLanguageString = voice.language // BCP-47 string
                let hypen: Character = "-"
                var countryCode: String?
                var languageCode = rawLanguageString
                if let index = rawLanguageString.firstIndex(of: hypen) {
                    languageCode = String(rawLanguageString.prefix(upTo: index))
                    let countryIndex = rawLanguageString.index(after: index)
                    if countryIndex != rawLanguageString.endIndex {
                        countryCode = String(rawLanguageString.suffix(from: countryIndex))
                    }
                }
                let audioPromptsLanguage = AudioPromptsLanguage(language: languageCode, country: countryCode)
                languages.append(audioPromptsLanguage)
            }
            return languages
        }
}


class AudioPromptsViewController: UIViewController {
    var voice: AVSpeechSynthesisVoice?
    let synthesizer = AVSpeechSynthesizer()
    private var speechLanguage: String = AVSpeechSynthesisVoice.currentLanguageCode() {
        didSet {
            if let newVoice = AVSpeechSynthesisVoice(language: speechLanguage){
//                engine = GravelEngine(audioFileUrl, locale: speechLanguage)
                voice = newVoice
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let languageList = AudioPromptsLanguage.retrieveAudioPromptsLanguages()
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(44)
        }
    }

    @objc private func buttonClick() {
        let language = "ja_jp"
        handleAudioPromptLanguageChanged(language: language)
        print("currentLanguage: \(speechLanguage)")
        let text = "ラップ 一. 四 秒"
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        synthesizer.speak(utterance)
    }

    private func handleAudioPromptLanguageChanged(language: String?) {
            var convertLanguage = language != "ZH_CT" ? language : "ZH_HK"
            // if notification language is different than the previous one we need to change
            // self.voice and remake the AudioPromptsBuilder ELSE return
            if convertLanguage == self.speechLanguage {
                return
            }

            var newLanguageCode: String = ""
            if let requestedLang = language {
                let hyphen: String = "-"
                let underscoreChar: Character = "_"
                var languageCode: String = ""
                var countryCode: String = ""
                var audioLanguageCodeiOS: String = ""
                // Need to parse language string because API languages are of this form: EN_US and
                // iOS language codes are en-US
                if let index = requestedLang.firstIndex(of: underscoreChar) {
                    languageCode = String(requestedLang.prefix(upTo: index)).lowercased()
                    let countryCodeIndex = requestedLang.index(after: index)
                    countryCode = String(requestedLang.suffix(from: countryCodeIndex)).uppercased()
                    audioLanguageCodeiOS = languageCode + hyphen + countryCode
                }

                // if incoming audio prompt language code is different than the previous, must remake AudioPromptsBuilder
                if !audioLanguageCodeiOS.isEmpty, speechLanguage != audioLanguageCodeiOS {
                    let allLangs: [AudioPromptsLanguage] = AudioPromptsLanguage.retrieveAudioPromptsLanguages()
                    var audioPromptLanguageCode: String = ""

                    // Filter for our selected language and if exact match is not found (language + country)
                    // then select first AudioPromptsLanguage with corresponding language code
                    // e.g "AR_AE" selected but iOS only supports "ar-SA", then choose "ar-SA" (or 1st available one)
                    let filteredLangCodes = allLangs.filter({ return $0.languageCode == languageCode })
                    if filteredLangCodes.isEmpty {
                        // if requested language is not supported by iOS, defer to chosing system's language
                        audioPromptLanguageCode = AVSpeechSynthesisVoice.currentLanguageCode()
                    } else {
                        let filteredCountryCodes = filteredLangCodes.filter({ return $0.countryCode == countryCode })
                        if filteredCountryCodes.isEmpty, let firstLangCountryCode = filteredLangCodes[0].countryCode {
                            audioPromptLanguageCode = languageCode + hyphen + firstLangCountryCode
                        } else {
                            audioPromptLanguageCode = audioLanguageCodeiOS
                        }
                    }
                    if !audioPromptLanguageCode.isEmpty {
                        newLanguageCode = audioPromptLanguageCode
                    }
                }
            } else {
                newLanguageCode = AVSpeechSynthesisVoice.currentLanguageCode()
            }

            if !newLanguageCode.isEmpty, speechLanguage != newLanguageCode {
                speechLanguage = newLanguageCode
            }
        }
}
