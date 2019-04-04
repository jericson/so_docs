# so_docs
A collection of scripts to use the data dump from Stack Overflow's dearly departed Documentation feature.

Pour one out for [Stack Overflow Documentation](https://meta.stackoverflow.com/questions/354217/sunsetting-documentation) and then grab [the data dump](https://archive.org/details/documentation-dump.7z). With a JSON parser in hand, you can use that content wherever your dreams take you. Just be sure to [provide proper attribution](https://meta.stackoverflow.com/questions/355115/documentation-is-read-only-what-s-next).

## Getting started

1. [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/).
2. Execute `gem install bundler` to install [Bundler](https://bundler.io/).
4. In the repository's directory, run `bundle install` to install all
   the required gems for the scripts.
3. Clone or download
   [this very repository](https://github.com/jericson/so_docs) on your
   machine.
5. In order to test the scripts and download the Documentation
   archive, run `bundle exec rake`.
6. If the test all succeed, you are all set to run the scripts from the `examples` directory.

## Libraries

*  [`so_docs.rb`](https://github.com/jericson/so_docs/blob/master/lib/so_docs.rb)&mdash;Library for loading and manipulating the JSON Documentation archive.
*  [`wayback-api.rb`](https://github.com/jericson/so_docs/blob/master/lib/wayback-api.rb)&mdash;Library to save and verify URLs on the [Wayback Machine](https://web.archive.org/). (Probably should be a separate project as it has no particular connection to the Documentation project other than I want to save pages there.)

## Examples

* [`get-archive.rb`](https://github.com/jericson/so_docs/blob/master/examples/get-archive.rb)&mdash;Downloads the archive and extracts it's contents. You only need to do this once.
* [`example2html.rb`](https://github.com/jericson/so_docs/blob/master/examples/example2html.rb)&mdash;Extract the HTML representation of an example. To see what this looks like, I made a copy of [Creating and Initializing Arrays](https://web.archive.org/web/20170912061936/http://jericson.github.io/docs/java/creating-java-arrays.html) in Java.
* [`revision2jekyll.rb`](https://github.com/jericson/so_docs/blob/master/examples/revision2jekyll.rb)&mdash;a Ruby script that prints a revision history item Markdown text.
* [`attribution2wbm.rb`](https://github.com/jericson/so_docs/blob/master/examples/attribution2wbm.rb)&mdash;Submits example or topic attribution to the Wayback Machine.
* [`submit2wbm.rb`](https://github.com/jericson/so_docs/blob/master/examples/submit2wbm.rb)&mdash;a Ruby script that submits all topics to the [Internet Archive Wayback Machine](https://web.archive.org/). Demonstrates how to use `doctags.json` and `topics.json`. (I ran it on August 16, 2017 after Documentation was put in readonly mode. There's probably no reason to run it again. Also, it doesn't work for C# as `c%23` isn't allowed in their URLs.)
* Stay tuned for other exciting scripts!<sup>*</sup>

## Contributions welcome

I'm working with Ruby, but I'm happy to accept scripts written in other languages as long as I can test them out. I'm also happy to include links to other project using Documentation archive in this README. Feel free to submit pull requests and I'll incorporate them as quickly as I can.

If there's something you'd like to see from the archive and can't figure out how to extract the content, feel free to [add an issue](https://github.com/jericson/so_docs/issues) or [ask on Meta Stack Overflow](https://meta.stackoverflow.com/questions/ask?tags=documentation,discussion,archive).

## Bugs

[![Build Status](https://travis-ci.org/jericson/so_docs.svg?branch=master)](https://travis-ci.org/jericson/so_docs)

* Tests are fragile. Changing the way these scripts work in even minor ways will break the tests. (Fortunately, the tests are also simple, so changing the expected `md5` hash result usually suffices.)
* The test framework also pulls in the entire archive from Archive.org and doesn't clean it up. This might be considered a feature by some.
* Getting user's display names requires a call to the [Stack Exchange API](http://api.stackexchange.com/docs/users-by-ids), which is subject to [rate limiting](http://api.stackexchange.com/docs/throttle). The method does not check to see if it's used the daily quota. Nor does it cache results. So it's easy to be throttled if you aren't careful. I've added an [application key](https://api.stackexchange.com/docs/authentication) since exceeding the quota was a leading cause of failure for Travis CI Continuous Integration tests.
* My code more or less reproduces a RDBMS&mdash;poorly. It would probably be smarter to load the JSON files into SQLite or something.

---
Footnote:

\* Offer contingent on author's creativity and reader's ability to be excited.
