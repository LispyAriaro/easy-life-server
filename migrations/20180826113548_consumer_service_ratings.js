
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('consumer_service_ratings', function (table) {
      table.increments('id').primary();
      table.integer('consumer_user_id');

      table.integer('service_id');
      table.integer('service_location_id');
      table.integer('rating');
      table.string('comment')

      table.timestamps();

      table.index(['consumer_user_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
