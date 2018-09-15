'use strict';

const K = require('knex');
var pg = require('pg');

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


exports.getAll = function (tableName) {
  knex(tableName).select('*').toString();
}

exports.getBy = function (tableName) {
  return function (columnName) {
    return function (columnVal) {
      var queryObj = {};
      queryObj[columnName] = columnVal;

      return knex(tableName).where(queryObj).select('*').toString();
    }
  }
}

exports.insert = function (insertObj) {
  return function (tableName) {
    return knex(tableName).insert(insertObj).returning('id').toString();
  }
}

exports.runInsertQuery_ = function (queryStr) {
  return function (client) {
    return function (error, success) {
      client.query(queryStr, function (err, result) {
        if (err) {
          error(err);
        } else {
          success(result);
        }
      });
      return function (cancelError, onCancelerError, onCancelerSuccess) {
        onCancelerSuccess();
      };
    };
  };
}
