
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('user_roles', function (table) {
      table.increments('id').primary();
      table.integer('user_id');

      table.string('role').notNull().defaultTo("consumer");

      table.index(['user_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};  
