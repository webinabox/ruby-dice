require 'securerandom'

module RubyDice
  class Wordlist
    attr_reader :words

    # Damn ugly... lets refactor sometime
    def initialize(options = {})
      default_options = { filename: 'eff_large_wordlist.txt' }
      options = default_options.merge(options)

      filename = options[:filename]
      filename += '.txt' if File.extname(filename) == ''

      search_paths = [
                       File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'assets')),
                       File.join(Dir.home, '.wordlists')
                     ]

      # Too convoluted?
      unless (full_path = (File.exist?(filename) ? filename : nil))
        path = search_paths.detect { |path| File.exist? File.join(path, filename) }
        full_path = File.join(path, filename)
      end

      File.open(full_path, 'r:UTF-8') { |f| @words = f.read }
      @words = @words.match(/(11111.+66666.+?)\n/m)[1].split("\n").map { |l| l.split(/[\t ]/)[1].strip }
    end

    def random(count = 5)
      (1..count).inject([]) do |selected|
        random = SecureRandom.random_number(@words.size)
        selected << @words[random]
      end
    end
  end
end
