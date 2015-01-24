module Inspector

  class Layer

    attr_reader :layer_id, :size, :tag

    def initialize(layer_id, size)
      @layer_id = layer_id
      @size = size.to_i
      @tag = nil
    end

    def short_id
      @layer_id[0,6]
    end

    def associate_tag(tag)
      @tag = tag
    end

    def to_s(full_id=false)
      msg = ""
      if full_id
        msg += @layer_id
      else
        msg += short_id
      end
      msg + " [#{Filesize.from("#{@size} B").pretty}]\n"
    end

  end

end
