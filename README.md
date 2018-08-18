### MyChange Server


### To start the server
The postgres database should already be running. It should have a database with name 'easylifedb'.

In development run:
```terminal
pulp run
```

### Environment variables that need to be set
```
JWT_SECRET

CLOUDINARY_APP_NAME
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET

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


##### Postman Collection
```
https://www.getpostman.com/collections/28d734849d598204160a
```

##### On using the Helmet library for security
```
http://scottksmith.com/blog/2014/09/21/protect-your-node-apps-noggin-with-helmet/
```

##### Libraries security check
```terminal
npm install nsp -g

nsp check
```

##### SendGrid For Sending Emails
- https://www.npmjs.com/package/sendgrid
- https://github.com/sendgrid/sendgrid-nodejs/blob/master/USE_CASES.md



##### References
- [NodeJs Express Security](https://expressjs.com/en/advanced/best-practice-security.html)
- [Timezone Foo](http://stackoverflow.com/questions/15347589/moment-js-format-date-in-a-specific-timezone)

For understanding database migration things with knex:
- [Knex Database migration tutorial](http://perkframework.com/v1/guides/database-migrations-knex.html)
- [Knex Database setup tutorial](http://www.dancorman.com/knex-your-sql-best-friend/)
- [Knex database migration tutorial](http://alexzywiak.github.io/running-migrations-with-knex/)
- [](https://medium.com/@HalahSalih/project-settings-for-an-express-app-with-knex-16959517b53b#.s60cgzlb8)
