'use strict';

var bcrypt = require('bcrypt');

exports.isPasswordCorrect = function(password) {
    return function(hash) {
        return bcrypt.compareSync(password, hash);
    }
}

exports.getPasswordHash = function(password) {
    var salt = bcrypt.genSaltSync(10);
    return bcrypt.hashSync(password, salt);
}
