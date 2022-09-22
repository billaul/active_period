# ActivePeriod
[![Gem Version](https://badge.fury.io/rb/active_period.svg)](https://badge.fury.io/rb/active_period)
[![Code Climate](https://codeclimate.com/github/billaul/period.svg)](https://codeclimate.com/github/billaul/period)
[![Inline docs](http://inch-ci.org/github/billaul/period.svg)](http://inch-ci.org/github/billaul/period)
[![RubyGems](http://img.shields.io/gem/dt/active_period.svg?style=flat)](http://rubygems.org/gems/active_period)

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

**ActivePeriod** was designed to simplify time-range manipulation, specialy with rails (>= 5) and user input   

**Warning** :
- A time-range take place between two **date** and it's different from an abstract duration of time
- **ActivePeriod** is limited at full day of time and will always round the starting and ending to the beginning and the ending of the day


## Quick view (TL;DR)
``` ruby
require 'active_period'

# Get all user created today
User.where(created_at: Period.today)

# Get how many days there is from the Voyager 2 launch
('20/07/1977'..Time.now).to_period.days.count

# Are we in 2021 ?
Time.now.in? Period.year('01/01/2021')

# Boundless period are also supported
Period.new('24/04/1990'..).days.each # => Enumerable
Period.new(..Time.now).months.reverse_each # => Enumerable

# Write a date for me (I18n supported)
Period.new('20/01/2017'...'20/01/2021').to_s
=> "From the 20 January 2017 to the 20 January 2021 excluded"

# Get all US holidays in the next week (see holiday's section below)
Period.next_week.holidays(:us)
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

# with one bound only
Period.new('01/01/2000'..)

# or in a rails Controller with params
Period.new(params[:start_date]..params[:end_date])

# or from a range
('01/01/2000'...'01/02/2000').to_period

# you can also use [] if .new is too long for you
Period['01/01/2000'...'01/02/2000']
```

**Note** : `to_period` will always return a **FreePeriod**

**FreePeriod** can be manipulated with `+` and `-`          
Doing so will move the start **and** the end of the period   
```ruby
Period.new('01/01/2000'..'05/01/2000') + 3.day
# is equal to
Period.new('04/01/2000'..'08/01/2000')
```

### StandardPeriod of time

Using **StandardPeriod** you are limited to strictly bordered periods of time      
These periods are `day`, `week`, `month`, `quarter` and `year`

```ruby
# To get the week, 42th day ago
Period.week(42.day.ago)

# To get the first month of 2020
Period.month('01/01/2020')

# or if you like it verbious
ActivePeriod::Month.new('01/01/2020')

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

You can quickly access convenient periods of time with `.(last|this|next)_(day|week|month|quarter|year)` and `.yesterday` `.today` `.tomorrow`

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

| HasMany -> [\<StandardPeriod>] | .days | .weeks | .months | .quarters | .years |
|-------------------------------|:----:|:-----:|:------:|:--------:|:-----:|
| FreePeriod                    |   X  |   X   |    X   |     X    |   X   |
| StandardPeriod::Day           |      |       |        |          |       |
| StandardPeriod::Week          |   X  |       |        |          |       |
| StandardPeriod::Month         |   X  |   X   |        |          |       |
| StandardPeriod::Quarter       |   X  |   X   |    X   |          |       |
| StandardPeriod::Year          |   X  |   X   |    X   |     X    |       |

Called from a **FreePeriod** all overlapping **StandardPeriod** are return     
Called from a **StandardPeriod** only strictly included **StandardPeriod** are return     
These methods return an **ActivePeriod::Collection** implementing **Enumerable**

#### Example
```ruby
# The FreePeriod from 01/01/2021 to 01/02/2021 has 5 weeks
Period.new('01/01/2021'...'01/02/2021').weeks.count # 5

# The StandardPeriod::Month for 01/01/2021 has 4 weeks
Period.month('01/01/2021').weeks.count # 4

# How many day in the current quarter
Period.this_quarter.days.count

# Get all the quarters overlapping a Period of time
Period.new(Time.now..2.month.from_now).quarters.to_a
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
# Get the third day, of the last week, of the second month, of the current year
Period.this_year.months.second.weeks.last.days.third
```

## Period Combination with `&` and `|`

You can use `&` to combine overlapping periods     
And `|` to combine overlapping and tail to head periods     
If the given periods cannot combine, then `nil` will be return       
The period we take the ending date from, determine if the ending date is included or excluded

#### Example for `&`
```ruby
# Overlapping periods
(Period['01/01/2021'..'20/01/2021'] & Period['10/01/2021'...'30/01/2021']).to_s
=> "From the 10 January 2021 to the 20 January 2021 included"

# Theses period cannot combine
Period.this_month & Period.next_month
=> nil
```

#### Example for `|`
```ruby
# Overlapping periods
(Period['01/01/2021'..'20/01/2021'] | Period['10/01/2021'...'30/01/2021']).to_s
=> "From the 01 January 2021 to the 30 January 2021 excluded"

# Example with tail to head
(Period.this_month | Period.next_month).to_s
=> "From the 01 September 2022 to the 31 October 2022 included"
(Period['01/01/2021'..'09/01/2021']  | Period['10/01/2021'..'20/01/2021']).to_s
=> "From the 01 January 2021 to the 20 January 2021 included"

# Theses period cannot combine
Period['01/01/2021'...'09/01/2021'] | Period['10/01/2021'..'20/01/2021']
=> nil
```

## Boundless Period

Boundless period are fully supported and work as you expect them to do    
The values `nil`, `''`, `Date::Infinity`, `Float::INFINITY` and `-Float::INFINITY` are supported as start and end
You can iterate on the `days`, `weeks`, `months`, `quarters` and `years` of an Endless period
```ruby
('01/01/2021'..nil).days.each { ... }
('01/01/2021'..'').days.each { ... }
('01/01/2021'..).days.each { ... }
```
You can reverse iterate on the `days`, `weeks`, `months`, `quarters` and `years` of an Beginless period
```ruby
(nil..'01/01/2021').days.reverse_each { ... }
(''..'01/01/2021').days.reverse_each { ... }
(..'01/01/2021').days.reverse_each { ... }
```

You can create an infinite period of time     
Obviously it's not iterable
```ruby
Period.new(nil..nil).to_s
=> "Limitless time range"
```

You can specifically forbid boundless period with `allow_endless`, `allow_beginless` or with `Period.bounded`
```ruby
Period.new('01/01/2020'..'', allow_endless: false)
Period.bounded('01/01/2020'..)
=> ArgumentError (The end date is invalid)

Period.new(..'01/01/2020', allow_beginless: false)
Period.bounded(..'01/01/2020')
=> ArgumentError (The start date is invalid)
```

## ActiveRecord

As **Period** inherit from **Range**, you can natively use them in **ActiveRecord** query

```ruby
# Get all book published this year
Book.where(published_at: Period.this_year)

# Get all users created after 01/01/2020
User.where(created_at: ('01/01/2020'..).to_period)
```

## Rails Controller

In a Controller, use the error handling to validate the date for you

```ruby
class BookController < ApplicationController
  def between
    begin
      # Retrieve books from the DB
      @books = Book.where(published: Period.bounded(params[:from]..params[:to]))
    rescue ArgumentError => e
      # Period will handle mis-formatted date and incoherent period
      # I18n is supported for errors messages
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
=> ArgumentError (The start date is invalid)

Period.new '01/02/3030'..'Bar'
Period.bounded '01/02/3030'..
=> ArgumentError (The end date is invalid)

Period.new '01/02/3030'..'01/01/2020'
=> ArgumentError (The start date is greater than the end date)
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
  period.i18n do |from, to, excluded_end|
    "You have from #{from.strftime(...)} until #{to.strftime(...)} to deliver the money !"
  end
```

## The tricky case of Weeks

Weeks are implemented following the [ISO 8601](https://en.wikipedia.org/wiki/ISO_week_date)      
So `Period.this_month.weeks.first` doesn't necessarily include the first days of the month     
Also a **StandardPeriod** and a **FreePeriod** covering the same range of time, may not includes the same `Weeks`

## TimeZone

Time zone are supported
If you change the global `Time.zone` of your app
If your Period [begin in a time zone and end in another](https://en.wikipedia.org/wiki/Daylight_saving_time), you have nothing to do

## Holidays

`ActivePeriod` include an optional support of the [gem holidays](https://github.com/holidays/holidays)      
If your project include this gem you can use the power of `.holidays` and `.holiday?`

`.holiday?` and `.holidays` take the same params as `Holidays.on` except the first one        
`Holidays.on(Date.civil(2008, 4, 25), :au)` become `Period.day('24/04/2008').holidays(:au)` or `Period.day('24/04/2008').holiday?(:au)`

```ruby
require 'holidays'
# Get all worldwide holidays in the current month
Period.this_month.holidays

# Get all US holidays in the next week
Period.next_week.holidays(:us)

# Get all US and CA holidays in the prev quarter
Period.prev_quarter.holidays(:us, :ca)

# First up coming `FR` holiday
holiday = (Time.now..).to_period.holidays(:fr).first
# return the next holiday with same options as the original `.holidays` collection
holiday.next
# return the previous holiday with same options as the original `.holidays` collection
holiday.prev
```

:warning:  If you call a `holidays` related method without the [gem holidays](https://github.com/holidays/holidays) in your project    
You will raise a `RuntimeError`
```ruby
Period.this_month.holidays
#=> RuntimeError (The gem "holidays" is needed for this feature to work)
```

## Planned updates & Idea

- [ ] ActiveRecord Serializer (maybe)
- [ ] Dedicated Exception for each possible error

## Bug reports

If you discover any bugs, feel free to create an [issue on GitHub](https://github.com/billaul/active_period/issues)        
Please add as much information as possible to help us in fixing the potential bug     
We also encourage you to help even more by forking and sending us a pull request

No issues will be addressed outside GitHub

## Maintainer

* Myself (https://github.com/billaul)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
