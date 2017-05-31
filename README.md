# La fabrique

Digital toolbox gathering tools, methods, media contents to foster projects.

## Getting Started

*These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.*

### Prerequisites

- ruby 2.4.0
- rails 5.0.1
- postgresql

```
Give examples
```

### Installing

```bash
git clone git@github.com:clairezed/la-fabrique.git
cd la-fabrique
bundle install
cp config/database_example.yml config/database.yml
# Update database.yml to cope with your own database connection credentials
bin/rake db:setup
bin/rake db:seed
rails server
```

Your website should be accessible at [localhost:3000](http://localhost:3000/).


### Dummy data

If you want to generate 20 fake lightweight tools, you can run : 

```bash
rake seeds:dummy_tools
```

## Running the tests

```bash
RAILS_ENV=test rake db:setup
RAILS_ENV=test bin/rake db:seed
rspec
```

The project could clearly have more tests. Don't hesitate to contribute, I'll be happy to help !

## Deployment

*Add additional notes about how to deploy this on a live system*
-> TODO

```
cp config/database_example.yml config/database_production.yml
```

## Built With

* [Bootstrap4](https://v4-alpha.getbootstrap.com/getting-started/introduction/) - alpha6

## Contributing

*Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.*
-> TODO


## Authors

* Development, integration : **Claire Zuliani** - [github account](https://github.com/clairezed) - [website](http://www.clairezuliani.com/)
* Design : **Phi²** - [website](http://phicarre.fr/)

## License

This project is licensed under the AGPL 3.0 License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

- back office inspired by [Modular Admin](https://github.com/modularcode/modular-admin-html)


### end writing open source docs

- Open source license : MIT, Apache 2.0, and GPLv3
- README : 
  - What does this project do? 
  - Why is this project useful?
  - How do I get started?
  - Where can I get more help, if I need it?
- Contributing guidelines
  - How to file a bug report (try using issue and pull request templates)
  - How to suggest a new feature
  - How to set up your environment and run tests
- Code of conduct