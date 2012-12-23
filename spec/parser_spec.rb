require 'spec_helper'
require 'polyglot'
require 'Treetop'

Treetop.load(File.dirname(__FILE__) + '/../lib/diag_down/sequence_diag_parser')

describe DiagDown::SequenceLanguageParser do
  before :all do
    @parser = DiagDown::SequenceLanguageParser.new
  end

  describe "#new" do
    it "takes no parameters and returns a parser object" do
      @parser.should be_an_instance_of DiagDown::SequenceLanguageParser
    end
  end

  it "successfully parses many cases" do
    teststrings = ['A->B:text', 'A-->B:text', '+A->B:text',
                   '+A-->B:text', '+A->+B:text', '+A-->+B:text',
                   'A->+B:text', 'A->B: text', 'A-->B: t3xt with sp4ces',
                   '-A->B:text', '-A-->B:text', '-A->-B:text', '-A-->-B:text',
                   'A->-B:text',
                   't3xt with sp4ces->t3xt with sp4ces: t3xt with sp4ces',
                   '+At3xt with sp4ces->+Bt3xt with sp4ces:text',
                   '-At3xt with sp4ces->-Bt3xt with sp4ces:text' ]

    teststrings.each { |s|
      @parser.parse(s).should be_true #parser.failure_reason
    }
  end

  it "returns nil on failing parses" do
    teststrings = ['A->B:unsupported sym$ol',
                   'unsupported sym$ol->B:text',
                   'A->unsupported sym$ol:text' ]

    teststrings.each { |s|
      @parser.parse(s).should be_nil #parser.failure_reason)
    }
  end

  it "correctly recognises dotted arrows" do
    teststrings = ['A-->B:text', '+A-->B:text', '+A-->+B:text',
                   'A-->B: t3xt with sp4ces', '-A-->B:text', 
                   '-A-->-B:text', 't3xt with sp4ces-->t3xt with sp4ces: t3xt with sp4ces',
                   '+At3xt with sp4ces-->+Bt3xt with sp4ces:text',
                   '-At3xt with sp4ces-->-Bt3xt with sp4ces:text' ]

    teststrings.each { |s|
      @parser.parse(s).arrow.dotted? #s
    }
  end

  it "correctly recognises object lifetime changes" do
    teststrings = ['A->B:text',
                  'A->B: text',
                  'A-->B:text',
                  'A-->B: t3xt with sp4ces',
                  't3xt with sp4ces->t3xt with sp4ces: t3xt with sp4ces']
    teststrings.each { |s|
      p = @parser.parse(s)
      p.arrow_source.activate?.should be_false
      p.arrow_source.deactivate?.should be_false
      p.arrow_destination.activate?.should be_false
      p.arrow_destination.deactivate?.should be_false
    }

    teststrings = ['+A->B:text', '+A-->B:text']
    teststrings.each { |s|
      p = @parser.parse(s)
      p.arrow_source.activate?.should be_true
      p.arrow_source.deactivate?.should be_false
      p.arrow_destination.activate?.should be_false
      p.arrow_destination.deactivate?.should be_false
    }

    teststrings = ['+A->+B:text', '+A-->+B:text',
                   '+At3xt with sp4ces->+Bt3xt with sp4ces:text']
    teststrings.each { |s|
      p = @parser.parse(s)
      p.arrow_source.activate?.should be_true
      p.arrow_source.deactivate?.should be_false
      p.arrow_destination.activate?.should be_true
      p.arrow_destination.deactivate?.should be_false
    }
 
    p = @parser.parse('A->+B:text')
    p.arrow_source.activate?.should be_false
    p.arrow_source.deactivate?.should be_false
    p.arrow_destination.activate?.should be_true
    p.arrow_destination.deactivate?.should be_false
    
    teststrings = ['-A->B:text', '-A-->B:text']
    teststrings.each { |s|
      p = @parser.parse(s)
      p.arrow_source.activate?.should be_false
      p.arrow_source.deactivate?.should be_true
      p.arrow_destination.activate?.should be_false
      p.arrow_destination.deactivate?.should be_false
    }

    teststrings = ['-A->-B:text', '-A-->-B:text',
                  '-At3xt with sp4ces->-Bt3xt with sp4ces:text']
    teststrings.each { |s|
      p = @parser.parse(s)
      p.arrow_source.activate?.should be_false
      p.arrow_source.deactivate?.should be_true
      p.arrow_destination.activate?.should be_false
      p.arrow_destination.deactivate?.should be_true
    }
   
    p = @parser.parse('A->-B:text')
    p.arrow_source.activate?.should be_false
    p.arrow_source.deactivate?.should be_false
    p.arrow_destination.activate?.should be_false
    p.arrow_destination.deactivate?.should be_true
  end
end


