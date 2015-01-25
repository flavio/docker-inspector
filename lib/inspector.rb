require 'json'
require 'filesize'
require 'set'
require 'singleton'
require 'shellwords'
require 'tempfile'
require 'thor'

require_relative 'inspector/cli'
require_relative "inspector/container"
require_relative 'inspector/exceptions'
require_relative 'inspector/helpers'
require_relative 'inspector/image'
require_relative 'inspector/layer'
require_relative 'inspector/layer_registry'
require_relative 'inspector/tag'
require_relative 'inspector/version'
