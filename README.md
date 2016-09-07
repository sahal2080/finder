[Homepage](http://rubyworks.github.com/finder) /
[Report Issue](http://github.com/rubyworks/finder/issues) /
[Source Code](http://github.com/rubyworks/finder)
( [![Build Status](https://secure.travis-ci.org/rubyworks/finder.png)](http://travis-ci.org/rubyworks/finder) )


# Finder

Finder is a straight-forward file finder for searching Ruby library paths.
It can handle RubyGems, Rolls and Ruby's standard site locals. It is both
more flexible and more robust the using `Gem.find_files` or searching the
`$LOAD_PATH` manually.


## Usage

First let's require the Finder library:
```ruby
    require 'finder'
```

Now you can provide a file pattern (glob) to either of the following functions:

### Load Path Lookup

To search for a file pattern within library load paths, use `Find.load_path`:
```ruby
    files = Find.load_path('example.rb', :relative=>true)
    file  = files.first
```

The method, by default, returns a path name _relative_ to the load path:
```ruby
    file.assert == 'example.rb'
```

To get the full path you can use the `aboslute` option:
```ruby
    files = Find.load_path('example.rb', :absolute=>true)
    file  = files.first

    File.expand_path(file).assert == file
    file.assert.end_with?('example.rb')
```

As with any Ruby script, we can require it:
```ruby
    file = Find.load_path('example.rb').first
    require file
```
Our `example.rb` script defines the global variable `$proof`, which loaded just fine:
```ruby
    $proof.assert == "plugin loading worked!"
```

### Feature Lookup

To search for a requirable files within library load paths, use `Find.feature`:

```ruby
    files = Find.feature('example')
    file  = files.first
```

The `feature` method returns relative paths (to the load path) by default and automatically handles 
extensions, just like `require`.
```ruby
    file.assert == 'example.rb'
```

To get the full path you can use the `aboslute` option:
```ruby
    files = Find.feature('example', :absolute=>true)
    file  = files.first

    File.expand_path(file).assert == file
    file.assert.end_with?('example.rb')
```


A common use case is to require all the files found in library load paths:
```ruby
    require 'finder'

    Find.feature('myapp/*').each do |file|
      require(file)
    end
```

Which is equivalent to:
```ruby
    Find.load_path('myapp/*.rb', :relative=>true).each do |file|
      require(file)
    end
```

Alternately you might load files only as needed. For instance, if a
command-line option calls for it.


### Import
In addition Finder has two optional Kernel extensions: `#import`
and `#import_relative`. These methods can be used like `#require`
and `#require_relative`, but load code directory into the 
current scope instead of the toplevel.
```ruby
    require 'finder/import'

    module My
      import('abbrev.rb')
    emd

    My::Abbrev::abbrev(['ruby'])
    => {"rub"=>"ruby", "ru"=>"ruby", "r"=>"ruby", "ruby"=>"ruby"}
```

> Make sure loaded scripts behave as intended when using `#import`
. For example, if `abbrev.rb`  were to define
itself using `::` toplevel namespace indicators, i.e. `::Abbrev`, 
the above import would **not** work.

## Copyrights

Finder is copyrighted opensource software.

    Copyright (c) 2009 Rubyworks

It can be modified and redistributed in accordance with the terms of
the **BSD-2-Clause** license.

See LICENSE.txt file for details.
