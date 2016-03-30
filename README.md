# Fetch

The goal of this package is to integrate a collection of API's and data feed capabilities into a single package, to enable the Julia programmer easy access to the entire universe of data. At the same time, the important secondary objective is to maintain the speed & efficiency one expects from Julia --- this means keeping dependencies to a minimum, preferring standard base Julia functionality, and making performant I/O a central focus.

Additionally, it is important to keep in mind the vast amounts of data out there that requires elvevated privileges for access --- subscriptions, licenses, authorization codes, pay-per-call, etc. With this in mind, developing methods for easy handling of these constraints for the programmer will be key, without sacrificing the security of any account details or credentials.

The initial development efforts will mostly surround historical financial & economic data, making use of the well-developed Quandl and Yahoo/Google Finance API's. Once this initial work is complete, development will likely then direct its attention to the countless other vendors, data types, and functionalities out there. Among them:

# The Universe

A relatively small list of some of the different kinds of data out there that would be awesome to have at one's fingertips:

- Social
    - Twitter
    - Facebook
- Financial
    - Streaming quotes
    - Account queries & order execution
- Sports
    - Team/player stats
    - Play-by-plays
- Geographical
    - Weather data
    - Vessel AIS tracking
- Music
    - Artist/album/track statistics
    - Lyrics downloads
