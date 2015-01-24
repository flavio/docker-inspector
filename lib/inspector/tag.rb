module Inspector

  class Tag

    attr_reader :image, :name, :layer

    def initialize(image, name, top_layer)
      @image     = image
      @name      = name
      @layer  = LayerRegistry.instance.register_layer(top_layer, self)
    end

    def layers
       @layer.ancestors
    end

  end

end
