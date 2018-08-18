// Update with your config settings.

module.exports = {
    development: {
        client: 'pg',
        connection: {
            host : '127.0.0.1',
            user : 'postgres',
            password : 'asdffdsa',
            database : 'easylifedb'
        },
        pool: {
            min: 2,
            max: 10
        },
        migrations: {
            tableName: 'knex_migrations'
        }
    },
};
