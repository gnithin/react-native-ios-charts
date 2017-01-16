// Adding custom Formatter for the integrating the y-Axis graph

/*
 This is a custom formatter that clubs numbers into thousands, Millions and Billions (K, M, B)
 */
class CustomNumberFormatter : NumberFormatter {
    override func string(from number: NSNumber) -> String? {
        // Add the logic to customize the number
        var num:Double = number.doubleValue;
        var finalNum:Int;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            finalNum = Int(num)
            return "\(sign)\(finalNum)";
        }
        
        // Short-cut to get the index of the units
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","B"];
        
        finalNum = Int(round(10 * num / pow(1000.0,Double(exp)))) / 10;
        
        return "\(sign)\(finalNum)\(units[exp-1])";
    }
}
