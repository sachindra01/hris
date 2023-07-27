//ConvertDate
convertedDate(date){
  if(date != null && date != ""){
    var splitDate = date.toString().split("-");
    var convertedDate = DateTime(int.parse(splitDate[0]), int.parse(splitDate[1]), int.parse(splitDate[2]));
    return convertedDate;
  } else{
    return null;
  }
}