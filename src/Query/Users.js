'use strict';

const K = require('knex');

var KnexFile = require('../../config/knexfile');
// console.log("KnexFile: ", KnexFile);

var knexDbConfigs = {};
knexDbConfigs['development'] = KnexFile['development'];
knexDbConfigs['production'] = KnexFile['production'];

var dbEnvVar = 'EasyLife_DbEnv';
var dbEnv = process.env[dbEnvVar] || 'development';
console.log(dbEnvVar + ": " + dbEnv + "\n");

var dbConfig = knexDbConfigs[dbEnv];
var knex = K(dbConfig);


// exports.getAll = knex('users').select('*').orderBy('first_name', 'desc');
exports.getAll = knex('users').select('*').toString();

exports.getBy = function (columnName) {
  return function(columnVal) {
    var queryObj = {};
    queryObj[columnName] = columnVal;

    return knex('users').where(queryObj).select('*').toString();
  }
}

exports.insert = function (uuid) {
  return function (username) {
    return function (phoneNumber) {
      return function (passwordHash) {
        return knex('users').insert({
          uuid: uuid, username: username, phone_number: phoneNumber, 
          password_hash: passwordHash
        }).toString();
      }
    }
  }
}