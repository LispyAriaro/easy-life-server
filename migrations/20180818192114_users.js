
exports.up = function (knex, Promise) {
  return Promise.all([
    knex.schema.createTable('users', function (table) {
      table.increments('id').primary();
      table.string('uuid');

      table.string('first_name');
      table.string('last_name');
      table.string('username');
      table.string('password_hash');

      table.string('phone_number');
      table.string('email_address');

      table.boolean('is_email_address_verified');
      table.boolean('is_phone_number_verified');

      table.string('image_url');
      table.string('cloudinary_image_public_id');

      table.boolean('is_active').notNull().defaultTo(true);

      table.integer('company_id');
      table.integer('created_by');

      table.timestamps();

      table.index(['uuid', 'phone_number']);
    })
  ])
};

exports.down = function (knex, Promise) {

};
