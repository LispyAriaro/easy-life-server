### EasyLife Server


### To start the server
The postgres database should already be running. It should have a database with name 'easylifedb'.

In development run:
```terminal
pulp run
```

### Environment variables that need to be set
```
JWT_SECRET

EasyLife_DbEnv
```

##### Database schema migration
If your knexfile.js does not exist then run:
```terminal
knex init
```

```terminal
knex migrate:make newtablename
```

```terminal
knex migrate:latest --env development
```

To create a seed file, run:
```
knex seed:make seed_name
```

To run seed files, execute:
```
knex seed:run
```

##### References
For understanding database migration things with knex:
- [Knex Database migration tutorial](http://perkframework.com/v1/guides/database-migrations-knex.html)
- [Knex Database setup tutorial](http://www.dancorman.com/knex-your-sql-best-friend/)
- [Knex database migration tutorial](http://alexzywiak.github.io/running-migrations-with-knex/)
- [](https://medium.com/@HalahSalih/project-settings-for-an-express-app-with-knex-16959517b53b#.s60cgzlb8)
