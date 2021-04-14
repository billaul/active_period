# ActivePeriod [![Gem Version](https://badge.fury.io/rb/active_period.svg)](https://badge.fury.io/rb/active_period) [![Code Climate](https://codeclimate.com/github/billaul/period.svg)](https://codeclimate.com/github/billaul/period) [![Inline docs](http://inch-ci.org/github/billaul/period.svg)](http://inch-ci.org/github/billaul/period)

ActivePeriod aims to simplify Time-range manipulation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_period'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_period

## Usage

**ActivePeriod** was designed to simplify time-range manipulation, specialy with rails (~> 5) and user input   

**Warning** :
- A time-range take place between two date and it's different from an abstract duration of time
- **ActivePeriod** is limited at full day of time and will always round the starting and ending to the beginning and the ending of the day


## Quick view (TL;DR)
``` ruby
require 'period'

# Get all user created today
User.where(created_at: Period.today)

# Get how many weeks there is from the beginning of time ?
Period.new('01/01/1970'..Time.now).weeks.count

# Is Trump still in charge ?
Time.now.in? Period.new('20/01/2017'...'20/01/2021')

# Get the week of an arbitrary date
Period.week('24/04/1990')

# Write a date for me (I18n supported)
Period.new('20/01/2017'...'20/01/2021').to_s
=> "From the 20 January 2017 to the 19 January 2021 included"
```

## Detailed view

There's two way to create and manipulate a period of time `FreePeriod` and `StandardPeriod`

### FreePeriod of time

You can declare **FreePeriod** as simply as :

```ruby
# With Date objects
Period.new(3.month.ago..Date.today)
# or with Strings
Period.new('01/01/2000'...'01/02/2000')
# or with a mix
Period.new('01/01/2000'..1.week.ago)
# or in a rails Controller with params
Period.new(params[:start_date]..params[:end_date])
```

**FreePeriod** can be manipulated with `+` and `-`          
Doing so will move the start **and** the end of the period   
```ruby
Period.new('01/01/2000'..'05/01/2000') + 3.day
# is equal to
Period.new('04/01/2000'..'08/01/2000')
```

### Standard Period of time

Using **StandardPeriod** you are limited to strictly bordered periods of time      
These periods are `day`, `week`, `month`, `quarter` and `year`

```ruby
# To get the week, 42th day ago
Period.week(42.day.ago)
# To get the first month of 2020
Period.month('01/01/2020')
# or if you like it verbious
Period::Month.new('01/01/2020')
# or if you need the current week
Period.week(Time.now)
```

**Note** : If you ask for a `month`, `quarter` of `year`, the day part of your param doesn't matter `01/01/2020` give the same result as `14/01/2020` or `29/01/2020`

**StandardPeriod** can be manipulated with `+` and `-` and will always return a **StandardPeriod** of the same type           
```ruby
# Subtraction are made from the start of the period
Period.month('10/02/2000') - 1.day
# Return the previous month
# Addition are made from the end
Period.month('10/02/2000') + 1.day
# Return the next month
Period.week('10/02/2000') + 67.day
# Return a week
```
**StandardPeriod** also respond to `.next` and `.prev`
```ruby
Period.month('01/01/2000').next.next.next
# Return the month of April 2020
```

You can quickly access close period of time with `.(last|this|next)_(day|week|month|quarter|year)` and `.yesterday` `.today` `.tomorrow`

```ruby
Period.this_week
# Same as Period.week(Time.now) but shorter
Period.next_month
# Return the next month
Period.last_year
# Return the last year
Period.today
# No comment
```

## HasMany

**FreePeriod** and some **StandardPeriod** respond to `.days`, `.weeks`, `.months`, `.quarters` and `.years`    
These methods return an array of **StandardPeriod** who are overlapping the current period

| HasMany -> [\<StandardPeriod>] | .days | .weeks | .months | .quarters | .years |
|-------------------------------|:----:|:-----:|:------:|:--------:|:-----:|
| FreePeriod                    |   X  |   X   |    X   |     X    |   X   |
| StandardPeriod::Day           |      |       |        |          |       |
| StandardPeriod::Week          |   X  |       |        |          |       |
| StandardPeriod::Month         |   X  |   X   |        |          |       |
| StandardPeriod::Quarter       |   X  |   X   |    X   |          |       |
| StandardPeriod::Year          |   X  |   X   |    X   |     X    |       |

#### Example
```ruby
# Get how many weeks there is from the beginning of time ?
Period.new('01/01/1970'..Time.now).weeks.count
# How many day in the current quarter
Period.this_quarter.days.count
# Get all the quarters overlapping a Period of time
Period.new(...).quarters
```

## BelongsTo

**StandardPeriod** respond to `.day`, `.week`, `.month`, `.quarter` and `.year`        
These methods return a **StandardPeriod** who include the current period    
**FreePeriod** does not respond to these methods

| BelongTo -> StandardPeriod | .day | .week | .month | .quarter | .year |
|----------------------------|:---:|:----:|:-----:|:-------:|:----:|
| FreePeriod                 |     |      |       |         |      |
| StandardPeriod::Day        |     |   X  |   X   |    X    |   X  |
| StandardPeriod::Week       |     |      |   X   |    X    |   X  |
| StandardPeriod::Month      |     |      |       |    X    |   X  |
| StandardPeriod::Quarter    |     |      |       |         |   X  |
| StandardPeriod::Year       |     |      |       |         |      |

#### Example with BelongTo and HasMany

```ruby
# Get the first day, of the last week, of the second month, of the current year
Period.this_year.months.second.weeks.last.days.first
```

## ActiveRecord

As **Period** inherite from **Range**, you can natively use them in **ActiveRecord** query

```ruby
# Get all book published this year
Book.where(published_at: Period.this_year)
```

## Rails Controller

In a Controller, use the error handling to validate the date for you

```ruby
class BookController < ApplicationController
  def between # match via GET and POST
    # Default value for the range in GET context
    params[:from] ||= 1.month.ago
    params[:to]   ||= Time.now

    begin
      # Retrieve books from the DB
      @books = Book.where(published: Period.new(params[:from]..params[:to]))
    rescue ArgumentError => e
      # Period will handle mis-formatted date and incoherent period
      # I18n is support for errors messages
      flash[:alert] = e.message
    end
  end
end
```

## I18n and to_s

I18n is supported for `en` and `fr`   

```ruby
Period.new('01/01/2000'...'01/02/2001').to_s
=> "From the 01 January 2000 to the 31 January 2001 included"
I18n.locale = :fr
Period.new('01/01/2000'...'01/02/2001').to_s
=> "Du 01 janvier 2000 au 31 janvier 2001 inclus"
```
Errors are also supported
```ruby
Period.new 'Foo'..'Bar'
#=> ArgumentError (The start date is invalid)
Period.new '01/02/3030'..'Bar'
#=> ArgumentError (The end date is invalid)
Period.new '01/02/3030'..'01/01/2020'
#=> ArgumentError (The start date is greater than the end date)
```

See `locales/en.yml` to implement your language support

If you need to change the format for a single call

```ruby
  period.to_s(format: 'Your Format')
  # or
  period.strftime('Your Format')
```
For a FreePeriod or if you need to print the start and the end of your period differently, use `.i18n`
```ruby
  period.i18n do |from, to|
    "You have from #{from.strftime(...)} until #{to.strftime(...)} to deliver the money !"
  end
```

## The tricky case of Weeks

Weeks are implemented following the [ISO 8601](https://en.wikipedia.org/wiki/ISO_week_date)      
So `Period.this_month.weeks.first` doesn't necessarily include the first days of the month

## TimeZone

Time zone are supported, you have nothing to do   
If you change the global `Time.zone` of your app, you have nothing to do    
If your Period [begin in a time zone and end in another](https://en.wikipedia.org/wiki/Daylight_saving_time), you have nothing to do

## Bug reports

If you discover any bugs, feel free to create an [issue on GitHub](https://github.com/billaul/period/issues)        
Please add as much information as possible to help us in fixing the potential bug     
We also encourage you to help even more by forking and sending us a pull request

No issues will be addressed outside GitHub

## Maintainer

* Myself (https://github.com/billaul)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
