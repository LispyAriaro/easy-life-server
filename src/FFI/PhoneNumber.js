var AwesomePhoneNumber = require('awesome-phonenumber');

exports.isNgNumberOk = function (phoneNum) {
  var isOk = false;

  var pn = new AwesomePhoneNumber(phoneNum, 'NG');
  if (pn.isValid()) {
    return true;
  } else {
    return false;
  }
};

exports.getStandardNumber = function (phoneNum) {
  var pn = new AwesomePhoneNumber(phoneNum, 'NG');
  if (pn.isValid()) {
    return pn.getNumber();
  } else {
    throw new Error("Invalid Nigerian phone number");
  }
};