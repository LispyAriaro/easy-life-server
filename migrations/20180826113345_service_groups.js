
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('service_groups', function (table) {
      table.increments('id').primary();

      table.string('name');
      table.integer('company_id');

      table.timestamps();

      table.index(['company_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
