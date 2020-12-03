# Monster Shop
## BE Mod 2: Weeks 4 & 5 Group Project
### [Background and Instructions](https://github.com/turingschool-examples/monster_shop_2005#background-and-description)<br>
Includes:
- Setup
- Learning goals
- Requirements
- User stories
- Rubric

## Table of Contents
- [Introduction](#introduction)
- [Demo](#demo)
- [Features](#features)
- [Team Members](#team-members)
- [Schema](#schema)
- [Adherence to Learning Goals](#adherence-to-learning-goals)

### Introduction

__Monster Shop__ was the project assigned to the 2008 Back End cohort during [Module 2](https://backend.turing.io/module2/). A [starter repo](https://github.com/turingschool-examples/monster_shop_2005) was provided which included some premade files. Students were put into groups of 3 or 4 and tasked with building off the starter repo to create a fictitious e-commerce platform.

The Monster Shop web application utilizes a model-view-controller design pattern and CRUD functionality. _Users_ can _register_ an account so they can place _items_ from multiple _merchants_ in a _shopping cart_ and then _checkout_. A user who works for a merchant (a _merchant employee_) can mark a registered user's items as _fulfilled_ based on the availability of the merchant's inventory. Since a user can order items from multiple merchants, all items must be marked as _fulfilled_ before an _admin_ user can mark the _order_ as _shipped_.

Students worked remotely over 10 days using Slack, Zoom, Github, and Github projects to attempt 54 assigned user stories. Test-driven development drove the creation of ReSTful routes with tests written in RSpec.

#### Demo
The app is deployed to Heroku [here](https://gentle-temple-14305.herokuapp.com/).

### Features
- Ruby 2.5.3
- Rails 5.2.4.3
- PostgreSQL
- Heroku
- ActiveRecord
- Gems
    - [`rspec-rails`](https://github.com/rspec/rspec-rails): testing suite
    - [`capybara`](https://github.com/teamcapybara/capybara): gives tools for feature testing
    - [`launchy`](http://www.launchy.net/): allows for `save_open_page` to see live version of browser
    - [`simplecov`](https://github.com/simplecov-ruby/simplecov): tracks test coverage
    - [`shoulda-matchers`](https://github.com/thoughtbot/shoulda-matchers): simplifies testing syntax
    - [`orderly`](https://github.com/jmondo/orderly) as an Rspec matcher

### Team Members

Sheryl Stillman - [GitHub](https://github.com/stillsheryl)

Jose Lopez - [GitHub](https://github.com/JoseLopez235)

Curtis Bartell - [GitHub](https://github.com/c-bartell)

Kiera Allen - [GitHub](https://github.com/KieraAllen)

### Schema
##### Created using [dbdiagram.io](https://dbdiagram.io/home)
![Monster Shop Schema](https://user-images.githubusercontent.com/46658858/98312807-b4db7e00-1f8f-11eb-803b-0271ccfe66a9.png)

### Adherence to Learning Goals

#### Rails

To organize our code we used an **MVC design pattern**, including appropriate logic within models, views, and controllers.
- **Models** - housed all our raw data logic without altering it, such as calculations and filtering or manipulating data
- **Views** - presented data without much logic: instance variables from our controllers along with methods from our models and the occasional conditional statement
- **Controllers** - included little data manipulation and model instance methods were created as needed

As requested by specific user stories, we used **flash messages** to alert a user to an error or missing information.

#### ActiveRecord

When creating queries that manipulated data in our models (e.g., calculating, selecting, filter, and ordering), we utilized **ActiveRecord** methods, first creating SQL queries to help us form the final ActiveRecord query structure.

#### Testing and Debugging

Integrative **feature tests** utilizing **sad path** testing were used in conjunction with unit tests when we decided we needed _class_ or _instance_ methods. We wrote additional **model tests** for validations and relationships.

_Feature Test Coverage_

![Monster Shop Feature Test Coverage](https://user-images.githubusercontent.com/46658858/98319931-13f4bf00-1f9f-11eb-83a2-98ba18d2dc0a.png)

_Model Test Coverage_

![Monster Shop Model Test Coverage](https://user-images.githubusercontent.com/46658858/98319803-ca0bd900-1f9e-11eb-9893-c3bb3f386892.png)

#### Web Applications

Throughout our construction of the app, we implemented proper **Representational State Transfer** style by confirming our routes contained the appropriate HTTP verbs, paths, and controllers/actions.
