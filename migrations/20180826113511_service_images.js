
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('service_images', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.integer('service_id');

      table.string('image_url');
      table.string('cloudinary_image_public_id');

      table.timestamps();

      table.index(['uuid', 'service_id']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
