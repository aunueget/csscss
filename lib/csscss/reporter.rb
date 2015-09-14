module Csscss
  class Reporter
    def initialize(redundancies, exactSelectors)
      @redundancies = redundancies
      @exactMatchSelectors = exactSelectors
    end

    def report(options = {})
      verbose      = options.fetch(:verbose, false)
      should_color = options.fetch(:color, true)

      io = StringIO.new
      @redundancies.each do |selector_groups, declarations|
        selector_groups = selector_groups.map {|selectors| "{#{maybe_color(selectors, :red, should_color)}}" }
        last_selector = selector_groups.pop
        count = declarations.size
        io.puts %Q(#{selector_groups.join(", ")} AND #{last_selector} share #{maybe_color(count, :red, should_color)} declaration#{"s" if count > 1})
        if verbose
          declarations.each {|dec| io.puts("  - #{maybe_color(dec, :yellow, should_color)}") }
        end
      end
	  
      @exactMatchSelectors.each do |selector|
        if selector[:count] > 1
          io.puts %Q({#{maybe_color(selector[:name], :red, should_color)}} repeated #{maybe_color(selector[:count], :red, should_color)} times )
        end
      end

      io.rewind
      io.read
    end

    private
    def maybe_color(string, color, condition)
      condition ? string.to_s.colorize(color) : string
    end
  end
end
