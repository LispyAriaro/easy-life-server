'use strict';

var jwt = require('jsonwebtoken');

exports.sign = function (payload) {
  return function (secret) {
    return jwt.sign(payload, secret);
  }
}

exports.signWithExpiry = function (payload) {
  return function (secret) {
    return function(expiry) {
      // Math.floor(Date.now() / 1000) + (60 * 60), 1 hour
      return jwt.sign(payload, secret, expiry);
    }
  }
}

exports.verify = function (token) {
  return function (secret) {
    return jwt.verify(token, secret);
  }
}
