#!/usr/bin/env ruby

require 'polyglot'
require 'Treetop'
require 'test/unit'

Treetop.load('sequence_diag_parser')

class TestSequenceParsing < Test::Unit::TestCase

  def test_successes
    parser = SequenceLanguageParser.new
    teststrings = ['A->B:text', 'A-->B:text', '+A->B:text',
                   '+A-->B:text', '+A->+B:text', '+A-->+B:text',
                   'A->+B:text', 'A->B: text', 'A-->B: t3xt with sp4ces',
                   '-A->B:text', '-A-->B:text', '-A->-B:text', '-A-->-B:text',
                   'A->-B:text',
                   't3xt with sp4ces->t3xt with sp4ces: t3xt with sp4ces',
                   '+At3xt with sp4ces->+Bt3xt with sp4ces:text',
                   '-At3xt with sp4ces->-Bt3xt with sp4ces:text' ]

    teststrings.each { |s|
      assert( parser.parse(s), parser.failure_reason)
    }
  end

  def test_failures
    parser = SequenceLanguageParser.new
    teststrings = ['A->B:unsupported sym$ol',
                   'unsupported sym$ol->B:text',
                   'A->unsupported sym$ol:text' ]

    teststrings.each { |s|
      assert( !parser.parse(s), parser.failure_reason)
    }
  end

  def test_dotted_cases
    parser = SequenceLanguageParser.new
    teststrings = ['A-->B:text', '+A-->B:text', '+A-->+B:text',
                   'A-->B: t3xt with sp4ces', '-A-->B:text', 
                   '-A-->-B:text', 't3xt with sp4ces-->t3xt with sp4ces: t3xt with sp4ces',
                   '+At3xt with sp4ces-->+Bt3xt with sp4ces:text',
                   '-At3xt with sp4ces-->-Bt3xt with sp4ces:text' ]

    teststrings.each { |s|
      p = parser.parse(s)
      assert( p.arrow.dotted?, s )
    }
  end

  def test_activate_cases
    parser = SequenceLanguageParser.new
    
    teststrings = ['A->B:text',
                  'A->B: text',
                  'A-->B:text',
                  'A-->B: t3xt with sp4ces',
                  't3xt with sp4ces->t3xt with sp4ces: t3xt with sp4ces']
    teststrings.each { |s|
      p = parser.parse(s)
      assert( ! p.arrow_source.activate?, s )
      assert( ! p.arrow_source.deactivate?, s )
      assert( ! p.arrow_destination.activate?, s )
      assert( ! p.arrow_destination.deactivate?, s )
    }

    teststrings = ['+A->B:text', '+A-->B:text']
    teststrings.each { |s|
      p = parser.parse(s)
      assert( p.arrow_source.activate?, s )
      assert( ! p.arrow_source.deactivate?, s )
      assert( ! p.arrow_destination.activate?, s )
      assert( ! p.arrow_destination.deactivate?, s )
    }

    teststrings = ['+A->+B:text', '+A-->+B:text',
                   '+At3xt with sp4ces->+Bt3xt with sp4ces:text']
    teststrings.each { |s|
      p = parser.parse(s)
      assert( p.arrow_source.activate?, s )
      assert( ! p.arrow_source.deactivate?, s )
      assert( p.arrow_destination.activate?, s )
      assert( ! p.arrow_destination.deactivate?, s )
    }
 
    p = parser.parse('A->+B:text')
    assert( ! p.arrow_source.activate? )
    assert( ! p.arrow_source.deactivate? )
    assert( p.arrow_destination.activate? )
    assert( ! p.arrow_destination.deactivate? )
    
    teststrings = ['-A->B:text', '-A-->B:text']
    teststrings.each { |s|
      p = parser.parse(s)
      assert( ! p.arrow_source.activate?, s )
      assert( p.arrow_source.deactivate?, s )
      assert( ! p.arrow_destination.activate?, s )
      assert( ! p.arrow_destination.deactivate?, s )
    }

    teststrings = ['-A->-B:text', '-A-->-B:text',
                  '-At3xt with sp4ces->-Bt3xt with sp4ces:text']
    teststrings.each { |s|
      p = parser.parse(s)
      assert( ! p.arrow_source.activate?, s )
      assert( p.arrow_source.deactivate?, s )
      assert( ! p.arrow_destination.activate?, s )
      assert( p.arrow_destination.deactivate?, s )
    }
   
    p = parser.parse('A->-B:text')
    assert( ! p.arrow_source.activate? )
    assert( ! p.arrow_source.deactivate? )
    assert( ! p.arrow_destination.activate? )
    assert( p.arrow_destination.deactivate? )
  end

end
