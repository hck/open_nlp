# OpenNlp

A JRuby wrapper for the Apache OpenNLP tools library, that allows you execute common natural language processing tasks, such as
 * sentence detection
 * tokenize
 * part-of-speech tagging
 * named entity extraction
 * chunks detection
 * parsing

## Installation

Add this line to your application's Gemfile:

    gem 'open_nlp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_nlp

## Usage

To use open_nlp classes, you need to require it in your sources

    require 'open_nlp'

Then you can create instances of open_nlp classes and use it for your nlp tasks

### Sentence detection

    sentence_detect_model = OpenNlp::Model::SentenceDetector.new("nlp_models/en-sent.bin")
    sentence_detector = OpenNlp::SentenceDetector.new(sentence_detect_model)
    sentence_detector.detect('The red fox sleeps soundly.')

### Tokenize

    token_model = OpenNlp::Model::Tokenizer.new("nlp_models/en-token.bin")
    tokenizer = OpenNlp::Tokenizer.new(token_model)
    tokenizer.tokenize('The red fox sleeps soundly.')

### Part-of-speech tagging

    pos_model = OpenNlp::Model::POSTagger.new(File.join("nlp_models/en-pos-maxent.bin"))
    pos_tagger = OpenNlp::POSTagger.new(pos_model)

    # to tag string call OpenNlp::POSTagger#tag with String argument
    pos_tagger.tag('The red fox sleeps soundly.')

    # to tag array of tokens call OpenNlp::POSTagger#tag with Array argument
    pos_tagger.tag(%w|The red fox sleeps soundly .|)

### Chunks detection

    # chunker also needs tokenizer and pos-tagger models
    # because it uses tokenizing and pos-tagging inside chunk task
    chunk_model = OpenNlp::Model::Chunker.new(File.join("nlp_models/en-chunker.bin"))
    token_model = OpenNlp::Model::Tokenizer.new("nlp_models/en-token.bin")
    pos_model = OpenNlp::Model::POSTagger.new(File.join("nlp_models/en-pos-maxent.bin"))
    chunker = OpenNlp::Chunker.new(chunk_model, token_model, pos_model)
    chunker.chunk('The red fox sleeps soundly.')

### Parsing

    # parser also needs tokenizer model because it uses tokenizer inside parse task
    parse_model = OpenNlp::Model::Parser.new(File.join(FIXTURES_DIR, "en-parser-chunking.bin"))
    token_model = OpenNlp::Model::Tokenizer.new("nlp_models/en-token.bin")
    parser = OpenNlp::Parser.new(parse_model, token_model)

    # the result will be an instance of OpenNlp::Parser::Parse
    parse_info = parser.parse('The red fox sleeps soundly.')

    # you can get tree bank string by calling
    parse_info.tree_bank_string

    # you can get code tree structure of parse result by calling
    parse_info.code_tree

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request