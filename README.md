# Rambobot

This a server side app for quizzes. It was built with Swift and backed by Vapor.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

What things you need to install the software and how to install them. At first verify swift installation:

```
eval "$(curl -sL check.vapor.sh)"
```

### Installing

A step by step series of examples that tell you have to get a development env running

#### Install Vapor

```
brew install vapor1
```

#### Build project

```
vapor1 build
```

#### Config file allowing access to the database

`Config/mysql.json`

```json
{
  "host": "localhost",
  "user": "root",
  "password": "",
  "database": "api"
}
```

End with import data dump into your MySQL DB. 

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

* **Sam Mejlumyan** - [smejl](https://github.com/smejl)

## Contributing

1. [Fork it](https://github.com/strongself/rambobot/fork)
2. Create your feature branch 
	`git checkout -b feature/fooBar`
3. Commit your changes 
	`git commit -am 'Add some fooBar'`
4. Push to the branch 
	`git push origin feature/fooBar`
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

