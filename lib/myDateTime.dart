Map<int,String> monthString = {
      1:"Jan",
      2:"Feb",
      3:"March",
      4:"April",
      5:"May",
      6:"June",
      7:"July",
      8:"Aug",
      9:"Sept",
      10:"Oct",
      11:"Nov",
      12:"Dec"
    };

  Map<int,String> weekString ={
    1:"Monday",
    2:"Tuesday",
    3:"Wednesday",
    4:"Thursday",
    5:"Friday",
    6:"Saturday",
    7:"Sunday",
  };

  leapYear(int year)
  {
    bool leapYear = false;

    bool leap =  ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0)
      leapYear = true;
    return leapYear;
  }

  daysInMonth(int monthNum, int year)
  {
    List<int> monthLength = new List(12);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum-1];
  }


  String thisWeekend(int day,int weekDay,int month,int year){

    List<String> list=[];
    String start="";
    String last="";

    int startDay = day-weekDay+1;
    if(startDay<=0){
      if(month==1){
        startDay = startDay + daysInMonth(12,year-1);
        start = startDay.toString() + monthString[12] +(year-1).toString();
      }else{
     startDay = startDay + daysInMonth(month-1, year);
      start = startDay.toString() + monthString[month-1] +(year).toString();
      }
    }else
    {
      start=startDay.toString()  + monthString[month] +(year).toString();
    }

    int lastDay = (day+(7-weekDay));
    if(lastDay > daysInMonth(month, year)){
      lastDay = lastDay % daysInMonth(month, year);
      last = lastDay.toString()  + monthString[(month==12?1:month+1)] +(month==12?year+1:year).toString();
    }else
    if(lastDay==0){
      lastDay = daysInMonth(month, year);
      last = lastDay.toString() + monthString[month]+(year).toString();
    }else{
           last = lastDay.toString() + monthString[month]  +(year).toString();
    }

    String l = start + '-' + last;
    return l;
  }