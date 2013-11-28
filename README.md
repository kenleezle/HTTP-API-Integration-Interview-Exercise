# Caredox Immunization Status - API Integration Exercise

## Summary

This is a ruby gem which provides an interface to the caredox immunization status HTTP API. It has activerecord-esque semantics.

## Installation

Download the gem from (https://github.com/kenleezle/HTTP-API-Integration-Interview-Exercise/blob/master/caredox_immunization_status-0.0.0.gem)
I did not publish this in rubygems because it is simply an exercise and of no real use to anyone.

``` ruby
gem install --local caredox_immunization_status-0.0.0.gem
```

## Usage

``` ruby
require 'rubygems'
require 'caredox_immunization_status'

istatus = ImmunizationStatus.find_by_person_id_and_state(1231231,'CA')
puts istatus.status
puts istatus.severity

```


