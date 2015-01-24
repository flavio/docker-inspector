module Inspector

  class Layer

    attr_reader :layer_id, :size, :tags
    attr_accessor :parent

    def initialize(layer_id, size)
      @layer_id = layer_id
      @size = size.to_i
      @tags = Set.new()
      @parent = nil
    end

    def short_id
      @layer_id[0,6]
    end

    def associate_tag(tag)
      @tags << tag
    end

    def ancestors
      if @parent
        @parent.ancestors << self
      else
        [self]
      end
    end

    def to_s
      "#{@layer_id} [#{Filesize.from("#{@size} B").pretty}]"
    end

  end

end
