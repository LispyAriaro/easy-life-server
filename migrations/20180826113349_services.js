
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('services', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.string('name');
      table.string('description');

      table.integer('company_id');
      table.integer('service_group_id');
      table.integer('service_category_id');

      table.float('price');

      table.boolean('is_active');
      table.timestamps();

      table.index(['uuid', 'company_id', 'service_group_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
