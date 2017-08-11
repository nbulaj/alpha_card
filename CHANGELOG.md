# AlphaCard gem Changelog

Reverse Chronological Order:

## `0.4.1` (2017-08-10)

https://github.com/nbulaj/alpha_card/compare/0.4.0...0.4.1

### Changes
* Fix `OpenSSL` error

## `0.4.0` (2016-10-07)

https://github.com/nbulaj/alpha_card/compare/0.3.0...0.4.0

### Breaking changes
* Dropped support of Ruby <= 2.2.2
* Removed deprecated methods (a.k.a. old transaction variables names)
* All transactions now returns `AlphaCard::Response` regardless of the operation result (except HTTP errors)
* `AlphaCard::Account` now works as global Alpha Card Merchant Account configuration (see docs)

### Other changes
* New AlphaCard transactions: `Auth`, `Credit`, `Validate`
* Own Attributes DSL with types, validations and other useful things
* Dropped `Virtus` dependency
* Fixed `check` payment (added new transaction variables for this type of operation)
* Credit Card authorization codes changes (removed dot at the end ot the message, improved `Response` API)
* Specs and documentation improvements

## `0.3.0` (2016-09-22)

https://github.com/nbulaj/alpha_card/compare/0.2.6...0.3.0

* Dropped support of Ruby 1.9.3 and jruby-1.7
* New AlphaCard transactions: `Void`, `Refund`, `Capture`, `Update`
* New AlphaCard transactions variables
* New AlphaCard transactions variables naming (**old is deprecated**)
* Improved transactions `.create` method to return response (not only the success indicator)
* Sale transaction request params fix
* Code refactoring
* Specs improvements
* Documentation improvements

## `0.2.6` (2016-03-24)

https://github.com/nbulaj/alpha_card/compare/0.2.4...0.2.6

* Documentation improvements
* `rest-client` removed from gem dependencies
* Code style fixes
* Code refactoring

## `0.2.4` (2015-07-24)

* Code style fixes
* New TravisCI tests strategies
* Dependencies update

## `0.2.2` (2015-07-11)

* New transaction variables
* `Shipping` object request params fixed

## `0.2.0` (2014-07-09)

* `AlphaCardError`
* Better errors handling

## `0.1.9` (2014-07-02)

* Errors handling
* Code refactoring
* Documentation improvements
* Specs
* Fixes

## `0.1.0` (2014-06-25)

* First stable release