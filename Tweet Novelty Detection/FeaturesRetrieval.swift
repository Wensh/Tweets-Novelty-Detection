//Check if person has his or hers own wikipage.

import Cocoa
import Foundation

var nameOfTwitterUser = "Johan_Cruyff"
var sparqlRequestPrsonOnDBpedia = "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=select+distinct+%3FConcept+where+%7B%0D%0Adbpedia%3A"+nameOfTwitterUser+"+rdf%3Atype+%3FConcept%0D%0AFILTER+regex%28%3FConcept%2C+%22Person%22%29%0D%0A%7D+&format=application%2Fsparql-results%2Bjson&timeout=30000&debug=on"

var sparqlRequestPrsonOnDBpediaAlternative = "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E+%0D%0APREFIX+dbpedia%3A+%3Chttp%3A%2F%2Fdbpedia.org%2F%3E%0D%0A%0D%0Aselect+%3FConcept+%0D%0Awhere+%7B%0D%0A%3Chttp%3A%2F%2Fdbpedia.org%2Fresource%2F"+nameOfTwitterUser+"%3E+rdf%3Atype+%3FConcept%0D%0AFILTER+regex%28%3FConcept%2C+%22Person%22%29%0D%0A%7D&format=text%2Fhtml&timeout=30000&debug=on"

/*
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dbpedia: <http://dbpedia.org/>

select ?Concept
where {
<http://dbpedia.org/resource/Johan_Cruyff> rdf:type ?Concept
FILTER regex(?Concept, "Person")
}
*/

var longurl = String(contentsOfURL: NSURL(string: sparqlRequestPrsonOnDBpedia)!, encoding: NSUTF8StringEncoding, error: nil)

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

func matchesForRegexInText(regex: String!, text: String!) -> [String] {
    let regex = NSRegularExpression(pattern: regex,
        options: nil, error: nil)!
    let nsString = text as NSString
    let results = regex.matchesInString(text,
        options: nil, range: NSMakeRange(0, nsString.length))
        as! [NSTextCheckingResult]
    return map(results) { nsString.substringWithRange($0.range)}
}
/*
if longurl!.rangeOfString("\"http://dbpedia.org/ontology/Person\"") != nil{
println("exists")
}
else {
println("doesn't exist")
}
*/

func sortPairsMixedWithIrrelevantTweets() {
    let pathOfSeed = "/Users/wenjiezhong/Desktop/processing.txt"
    var seedWords = String(contentsOfFile: pathOfSeed, encoding: NSUTF8StringEncoding, error: nil)
    let pathOfirrelevantWords = "/Users/wenjiezhong/Desktop/irprocessing.txt"
    var irrelevantWords = String(contentsOfFile: pathOfirrelevantWords, encoding: NSUTF8StringEncoding, error: nil)
    
    
    var seedWordsArray = [String]()
    var pairsArray = [String]()
    var outputArray = [String]()
    var trimmed = [String]()
    var trimmedIrrelevantWords = [String]()
    var irrelevantWordsArray = [String]()
    seedWordsArray = seedWords!.componentsSeparatedByString("\n")
    irrelevantWordsArray = irrelevantWords!.componentsSeparatedByString("\n")
    
    var sixCount = 1
    var sixResetter = 2
    
    for j in 0..<seedWordsArray.count {
        trimmed.append((seedWordsArray[j] as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
    }
    
    for j in 0..<irrelevantWordsArray.count {
        trimmedIrrelevantWords.append((irrelevantWordsArray[j] as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
    }
    
    
    for i in 0..<trimmed.count-25 {
        while sixCount < trimmedIrrelevantWords.count {
            var diceRoll = Int(arc4random_uniform(3))
            if diceRoll == 0 {
                pairsArray.append("\(trimmed[i]),\(trimmedIrrelevantWords[sixCount])")
                sixCount++
            }
            else if diceRoll == 1{
                pairsArray.append("\(trimmedIrrelevantWords[sixCount]),\(trimmed[i])")
                sixCount++
            }
            else {
                pairsArray.append("\(trimmedIrrelevantWords[sixCount]),\(trimmedIrrelevantWords[i])")
                sixCount++
            }
        }
        sixCount = i+2
    }
    pairsArray.shuffle()
    saveToDocument(pairsArray, "sortedPairsWithIrrelevantTweets.csv")
}

func saveToDocument(array: [String], filename: String) {
    if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
        let dir = dirs[0] //documents directory
        
        let pathToWrite = dir.stringByAppendingPathComponent(filename)
        let joinedSorted = "\n".join(array)
        joinedSorted.writeToFile(pathToWrite, atomically:true, encoding:NSUTF8StringEncoding)
    }
}













