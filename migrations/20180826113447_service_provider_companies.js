
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('service_provider_companies', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.string('name');

      table.boolean('is_active');
      table.timestamps();

      table.index(['id', 'uuid']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
