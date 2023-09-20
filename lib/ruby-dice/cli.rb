require 'thor'
require 'ruby-dice'

module RubyDice
  class CLI < Thor
    default_task :throw

    desc 'throw', 'Generate and copy a passphrase'
    option :length, type: :numeric, default: 5, aliases: :l, desc: 'Amount of words to use'
    option :print, type: :boolean, default: false, aliases: :p, desc: 'Output passphrase to terminal'
    option :wordlist, type: :string, default: nil, aliases: :w, desc: 'Use a custom wordlist file', banner: 'filename'
    option :camelcase, type: :boolean, default: false, aliases: :c, desc: 'convert passphrase to convert words into camelCase'
    option :capitalize, type: :boolean, default: false, aliases: :C, desc: 'convert words to capitalized'
    option :separator, type: :string, default: ' ', aliases: :s, desc: 'Separator to use between words', banner: 'separator'
    option :numbers, type: :boolean, default: true, aliases: :n, desc: 'Generate a passphrase with at least one number'
    option :randomize_numbers, type: :boolean, default: true, aliases: :r, desc: 'Randomize the position of the number in the passphrase'
    option :iterations, type: :numeric, default: 1, aliases: :i, desc: 'Generate multiple passphrases at once'

    def throw
      passphrase_options = {}.tap do |o|
        o[:words] = options['length']
        o[:wordlist] = options['wordlist']
        o[:camelcase] = options['camelcase']
        o[:numbers] = options['numbers']
      end

      (1..options[:iterations]).each do |_count|
        passphrase = RubyDice::Passphrase.generate passphrase_options
        puts "Passphrase copied to clipboard" if options[:iterations] == 1 && copy_to_clipboard(passphrase)
        puts passphrase if options['print'] || options[:iterations] > 1
      end
    end

    no_commands do
      def copy_to_clipboard(passphrase)
        if RUBY_PLATFORM.downcase.include?("darwin")
          IO.popen('pbcopy', 'w+') do |clipboard|
            clipboard.write(passphrase)
          end

          true
        elsif RUBY_PLATFORM.downcase.include?("linux") # requires xsel to be installed
          IO.popen('xsel --clipboard --input', 'r+') do |clipboard|
            clipboard.puts passphrase
          end

          true
        else
          false
        end
      rescue Errno::ENOENT => e
        puts "Error: Unable to copy to clipboard. #{e.message}, please ensure the required package is installed."
        exit 1
      end
    end

  end
end
