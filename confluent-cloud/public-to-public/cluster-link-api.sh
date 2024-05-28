#!/usr/bin/env bash


source cluster-link-rc.sh

# (Optional) Create an API-KEY

# set environment (primary)
confluent environment use $primary_environment
confluent api-key create --resource $primary_id

#+------------+------------------------------------------------------------------+
#| API Key    | DM73Q5GXX44EMLW3                                                 |
#| API Secret | 5d9/slMcIpEO/4etMNQkGQScItYRlAJa80mbn9Yezo1vEUtcdrh7NQWeM859cuDK |
#+------------+------------------------------------------------------------------+


confluent environment use $secondary_environment                                                                                                                                                                 ‹system: ruby 2.6.10p210›
confluent api-key create --resource $secondary_id                                                                                                                                                                ‹system: ruby 2.6.10p210›

#+------------+------------------------------------------------------------------+
#| API Key    | TYEAS5ALN7FY5ZV7                                                 |
#| API Secret | zjGJOj3k23vZidcLDpoF2bQEVahRBAxxOr3T23fH6Q9nIUfUjk8UXkKz4Oy9Wm7P |
#+------------+------------------------------------------------------------------+
