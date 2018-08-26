
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('service_categories', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.string('name');

      table.timestamps();

      table.index(['uuid']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
