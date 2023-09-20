require 'ruby-dice'

describe RubyDice::Passphrase do
  it 'returns a passphrase of the requested size' do
    passphrase = RubyDice::Passphrase.generate(words: 5)
    expect(passphrase.split(' ').size).to eql(5)
  end

  it 'returns a passphrase from a custom wordlist' do
    file = File.join(File.dirname(__FILE__), 'fixtures', 'five')
    passphrase = RubyDice::Passphrase.generate(wordlist: file)
    expect(passphrase.split(' ').size).to eql(5)
  end

  it 'returns a camel cased passphrase' do
    words = %w[mary had a little lamb]
    camel = 'maryHadALittleLamb'
    allow_any_instance_of(RubyDice::Wordlist).to receive(:random).and_return(words)
    passphrase = RubyDice::Passphrase.generate(camelcase: true)
    expect(passphrase).to eql(camel)
  end

  it 'returns a passphrase with a number' do
    words = %w[mary had a little lamb]
    with_number = /mary had a little lamb\d+/
    allow_any_instance_of(RubyDice::Wordlist).to receive(:random).and_return(words)
    passphrase = RubyDice::Passphrase.generate(numbers: true)
    expect(passphrase).to match(with_number)
  end
end

describe RubyDice::Wordlist do
  context 'with the default wordlist' do
    let(:wordlist) { RubyDice::Wordlist.new }

    it 'loads the default wordlist' do
      expect(wordlist.words.size).to eql(7776)
    end

    it 'returns a random list of words' do
      expect(wordlist.random(5).size).to_not eql(wordlist.random(5))
    end

    it 'returns the specified amount of words' do
      expect(wordlist.random(9).size).to eql(9)
    end
  end

  context 'with a custom wordlist' do
    it 'returns a random list of words' do
      file = File.join(File.dirname(__FILE__), 'fixtures', 'five')
      wordlist = RubyDice::Wordlist.new(file)

      expect(wordlist.random(5).size).to eql(5)
      expect(wordlist.words.size).to eql(5)
      expect(wordlist.words - %w[mary had a little lamb]).to eql([])
    end
  end
end
