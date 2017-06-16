module Processors
  class Base
    def self.process(text)
      new(text).processed_text
    end

    def initialize(text)
      @text = text
    end

    attr_reader :text
  end
end
