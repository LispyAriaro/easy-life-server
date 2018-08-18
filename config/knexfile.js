// Update with your config settings.

module.exports = {
  development: {
    client: 'pg',
      connection: {
        host : '127.0.0.1',
        user : 'postgres',
        password : 'asdffdsa',
        database: 'easylifedb'
      },
      pool: {
        min: 2,
        max: 10
      },
      migrations: {
        tableName: 'knex_migrations'
      }
    },
    staging: {
      client: 'postgresql',
      connection: {
        database: 'my_db',
        user: 'username',
        password: 'password'
      },
      pool: {
        min: 2,
        max: 10
      },
      migrations: {
        tableName: 'knex_migrations'
      }
    },
  production: {
    client: 'pg',
    connection: {
      host : 'mychangedbrdsffffffff.xxxxxxxxxx.eu-central-1.rds.amazonaws.com',
      user : 'postgres',
      password : '',
      database: 'easylifedb'
    },
    pool: {
      min: 2,
      max: 10
    },
    migrations: {
      tableName: 'knex_migrations'
    }
  }
};
