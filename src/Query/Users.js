'use strict';

const knex = require('knex');

var KnexFile = require('../../config/knexfile');
// console.log("KnexFile: ", KnexFile);

var knexDbConfigs = {};
knexDbConfigs['development'] = KnexFile['development'];
knexDbConfigs['production'] = KnexFile['production'];

var dbEnvVar = 'EasyLife_DbEnv';
var dbEnv = process.env[dbEnvVar] || 'development';
console.log("MyChange_DbEnv: ", dbEnv);

var currentDbConfig = knexDbConfigs[dbEnv];
var configuredKnex = knex(currentDbConfig);

// exports.getAll = knex('users').select('*').orderBy('first_name', 'desc');
exports.getAll = configuredKnex('users').select('*').toSQL().sql;

exports.insertUser = function (uuid) {
  return configuredKnex('users').insert(recordData).toSQL().sql;
}

exports.insert = function (uuid) {
  return function (username) {
    return function (phoneNumber) {
      return function (passwordHash) {
        return configuredKnex('users').insert({
          uuid: uuid, username: username, phone_number: phoneNumber, 
          password_hash: passwordHash
        }).toSQL().sql;
      }
    }
  }
}