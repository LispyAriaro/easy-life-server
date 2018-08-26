
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('locations', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.string('name');

      table.integer('company_id');
      table.integer('latitude');
      table.integer('longitude');
      table.string('google_plus_code');

      table.boolean('is_verified');
      table.boolean('is_active');

      table.timestamps();

      table.index(['uuid', 'company_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
