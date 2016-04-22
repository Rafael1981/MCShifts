function startTime() {
    var today = new moment();
    var D = today.format("D");
    var M = today.format("M");
    var Y = today.format("YYYY");
    var h = today.format("HH");
    var m = today.format("mm");
    if (m > 0  && m < 15)
    { m = 0;}
    else if (m > 15  && m < 30)
    { m = 15;}
    else if (m > 30  && m < 45)
    { m = 30;}
    else if (m > 45)
    { m = 45;}
    // m = checkTime(m);
    // s = checkTime(s);
    if (document.getElementById('log_signout')) {
        document.getElementById('log_signout').value =
            D + "/" + M + "/" + Y + " " + h + ":" + m ;
    }else {
        document.getElementById('log_signin').value =
            D + "/" + M + "/" + Y + " " + h + ":" + m;
    }
    document.getElementById('time').innerHTML =
    D + "/" + M + "/" + Y + " " + h + ":" + m ;
    var t = setTimeout(startTime, 1000);
}
function checkTime(i) {
    if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
    return i;
}