module Inspector

  class Tag

    attr_reader :image, :name, :top_layer, :layers

    def initialize(image, name, top_layer)
      @image     = image
      @name      = name
      @top_layer = top_layer
      @_layers   = []
    end

    def layers
      if @_layers.empty?
        parse_layer(top_layer, @_layers)
        @_layers.first.associate_tag(self)
        @_layers.reverse!
      end
      @_layers
    end

    private

    def parse_layer(layer_id, layers)
      layer_dir = "/var/lib/docker/graph/#{layer_id}"
      if File.exists?(layer_dir)
        data = JSON.parse(File.read(File.join(layer_dir, "json")))
        size = File.read(File.join(layer_dir, "layersize"))
        layers << Layer.new(layer_id, size)
        if data["parent"]
          parse_layer(data["parent"], layers)
        end
      end
    end

  end

end
