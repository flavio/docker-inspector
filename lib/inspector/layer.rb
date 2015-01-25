module Inspector

  class Layer

    attr_reader :layer_id, :size, :tags, :data
    attr_accessor :parent

    def initialize(layer_id, size, data)
      @layer_id = layer_id
      @data     = data
      @size     = size.to_i
      @tags     = Set.new()
      @parent   = nil
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

    def to_row
      tags = @tags.map{|t| "#{t.image.name}:#{t.name}"}.join(", ")
      if tags.empty?
        tags = "-"
      end
      [
        @layer_id,
        Filesize.from("#{@size} B").pretty,
        tags,
        @data['created']
      ]
    end

  end

end
