require 'ruby_svg_light'

module DiagDown
  module Render

    class SVG
      def initialize
        @canvas = RubySVGLight::Document.new
        
        #Set Global Options
        options = {:font_size=>'18px'}
        @canvas.options(options)

        #Keep a list of things to draw
        @arrows = []
        @timelines = []
      end

      # state = :none, :activate, :deactivate
      def arrow(source, dest, text, is_dotted = false,
                source_new_state = :none, dest_new_state = :none)

        @timelines.push(source) if ! @timelines.include?(source)
        @timelines.push(dest) if ! @timelines.include?(dest)
        
        @arrows.push({ :source => @timelines.index(source),
                       :dest => @timelines.index(dest),
                       :text => text, :dotted? => is_dotted,
                       :source_new_state => source_new_state,
                       :dest_new_state => dest_new_state })
      end

      def render
        xoffset = 0
        intercol = 100
        interline = 50
        line_length = @arrows.length * interline + 10

        @timelines.each { |label|
          # labels
          @canvas.text(xoffset, 20, label)

          # lines
          @canvas.line(xoffset+15, 30, 0, line_length)
          xoffset += intercol
        }

        yoffset = interline
        @arrows.each { |arrow|
          seg = [ arrow[:source], arrow[:dest] ]
          @canvas.line(intercol * seg.min + 15, yoffset,
                       intercol * (seg.max - seg.min), 0)
          yoffset += interline
        }
      end

      def to_s
        return @canvas.to_s
      end

      def to_file(filename)
        return @canvas.to_file(filename)
      end
    end

  end
end
