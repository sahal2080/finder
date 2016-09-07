require 'rbconfig'
require 'finder/base'
require 'finder/roll'
require 'finder/gem'
require 'finder/site'

module Finder

  # Main interface for Finder library.
  #
  module Find
    extend self

    # TODO: expand on extensions
    EXTENSIONS = %w{.rb .rbx .so}

    ##
    # Find matching paths by searching through:
    #   * Gem System: Paths of and within installed gems using RubyGems finder methods.
    #   * Site System: Paths in `$LOAD_PATH` and `RbConfig::CONFIG['datadir']`.
    #   * Rolled Libraries System (WIP): Current or latest files within a library.
    #
    # @param [String] match
    #   File glob to match against.
    #
    # @param [Hash] options
    #   Search options.
    #
    # @example
    #   Find.path('lib/foo/*')
    #
    # @option options [String] :from (gem, roll)
    #   Specific gem to search. Only applicable in RubyGems and Rolled Libraries systems.
    #
    # @option options [String] :version (roll, gem)
    #   Specific gem/library version to search. Only applicable in XXX system
    #
    # @option options [true,false] :activate (gem, )
    #   Activate the gem if it has matching files. Applicable in
    #
    # @return [Array<String>] List of absolute paths.
    #
    def path(match, options={})
      found = []
      systems.each do |system|
        found.concat system.path(match, options)
      end
      found.uniq
    end

    # Shortcut for #path.
    #
    #   Find['lib/foo/*']
    #
    alias_method :[], :path

    #
    # Searching through all systems for matching data paths.
    #
    # @param [String] match
    #   File glob to match against.
    #
    # @param [Hash] options
    #   Search options.
    #
    # @option options [String] :from (roll, gem)
    #   Specific gem/library to search. Applicable in
    #
    # @option options [String] :version (roll, gem)
    #   Specific gem/library version to search. Applicable in
    #
    # @option options [true,false] :activate (roll, gem)
    #   Activate the library if it has matching files. Applicable in
    #
    # @example
    #   Find.data_path('bar/*')
    #
    def data_path(match, options={})
      found = []
      systems.each do |system|
        found.concat system.data_path(match, options)
      end
      found.uniq
    end

    # Searching all systems' load paths for matching patterns.
    # * Rolled Libraries system: Search Roll system for current or latest library files. This is useful
    # for plugin loading. This only searches activated libraries or the most recent version
    # of any given library.
    #
    # @param [String] match
    #   File glob to match against.
    #
    # @param [Hash] options
    #   Search options.
    #
    # @example
    #   Find.load_path('bar/*')
    #
    # @option options [true,false] :absolute (site, roll)
    #   Return absolute paths instead of relative to load path. Applicable in
    #
    # @option options [true,false] :relative
    #   . Applicable in
    #
    # @option options [true,false] :activate (roll, gem)
    #   Activate the gem/library if it has matching files. Applicable in
    #
    # @option options [String] :from (roll, gem)
    #   Specific gem/library to search. Applicable in
    #
    # @option options [String] :version (roll, gem)
    #   Specific gem/library version to search. Applicable in
    #
    # @return [Array<String>] List of paths.
    #
    def load_path(match, options={})
      found = []
      systems.each do |system|
        found.concat system.load_path(match, options)
      end
      found.uniq
    end

    ## Searching through all systems for matching load paths.
    ##
    ## @param [String] match
    ##   File glob to match against.
    ##
    ## @example
    ##   Find.require_path('bar/*')
    ##
    #def require_path(match, options={})
    #  found = []
    #  systems.each do |system|
    #    found.concat system.require_path(match, options)
    #  end
    #  found.uniq
    #end

    #
    # Like #load_path but searches only for requirable files through all systems
    # returns relative paths by default.
    #
    # @param [String] match
    #   File glob to match against.
    #
    # @example
    #   Find.feature('ostruct')
    #
    def feature(match, options={})
      found = []
      systems.each do |system|
        found.concat system.feature(match, options)
      end
      found.uniq
    end

    #
    # List of supported library management systems.
    #
    def systems
      @systems ||= (
        systems = []
        systems << Roll if defined?(::Library)
        systems << Gem  if defined?(::Gem)
        systems << Site
        systems
      )
    end

  end

end
