require 'diag_down/svg_renderer'
require 'polyglot'
require 'Treetop'

Treetop.load(File.dirname(__FILE__) + '/sequence_diag_parser')

module DiagDown
  class Interpreter
    def initialize
      @renderer = DiagDown::Render::SVG.new
      @parser = DiagDown::SequenceLanguageParser.new
    end

    def render(text)
      text.each_line { |line|
        p = @parser.parse(line)
        if p
          @renderer.arrow(p.arrow_source.label.text_value,
                          p.arrow_destination.label.text_value,
                          p.label.text_value, p.dotted?,
                          :none, :none)
        end
      }
      @renderer.render
      return @renderer.to_s
    end
  end
end

