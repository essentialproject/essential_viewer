/*==================================================
 *  Localization of labellers.js
 *==================================================
 */

Timeline.GregorianDateLabeller.monthNames["vi"] = [
    "Thng 1", "Thng 2", "Thng 3", "Thng 4", "Thng 5", "Thng 6", "Thng 7", "Thng 8", "Thng 9", "Thng 10", "Thng 11", "Thng 12"
];

Timeline.GregorianDateLabeller.labelIntervalFunctions["vi"] = function(date, intervalUnit) {
    var text;
    var emphasized = false;
    
    var date2 = Timeline.DateTime.removeTimeZoneOffset(date, this._timeZone);
    
    switch(intervalUnit) {
    case Timeline.DateTime.DAY:
    case Timeline.DateTime.WEEK:
        text = date2.getUTCDate() + "/" + (date2.getUTCMonth() + 1);
        break;
    default:
        return this.defaultLabelInterval(date, intervalUnit);
    }
    
    return { text: text, emphasized: emphasized };
};