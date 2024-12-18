module RubyDice
  class Passphrase
    def self.generate(options = {})
      default_options = { words: 5, separator: '-', camelcase: false, capitalize: true, numbers: true, randomize_numbers: true }
      options = default_options.merge(options)

      wordlist_options = {}
      wordlist_options[:wordlist] = options.delete(:wordlist)

      wordlist = Wordlist.new(wordlist_options)
      words = wordlist.random(options[:words])

      if !words.detect { |w| w.match(/\d/) } && options[:numbers]
        if options[:randomize_numbers]
          words[SecureRandom.random_number(words.size)] += SecureRandom.random_number(100).to_s
        else
          words[-1] += SecureRandom.random_number(100).to_s
        end
      end

      if options[:capitalize] || options[:camelcase]
        words.map!(&:capitalize)
        words[0] = words[0].downcase if options[:camelcase]
      end

      phrase = words.join(options[:separator])

    phrase
  end
end
end
