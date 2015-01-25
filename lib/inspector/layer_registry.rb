module Inspector

  class LayerRegistry
    include Singleton

    def initialize
      @layers = {}
    end

    def register_layer(layer_id, tag=nil)
      if @layers.has_key?(layer_id)
        @layers[layer_id].associate_tag(tag) if tag
        return @layers[layer_id]
      end

      layer_dir = "/var/lib/docker/graph/#{layer_id}"
      if !File.exists?(layer_dir)
        raise LayerNotFound.new("Cannot find layer #{layer_id}")
      end
      data = JSON.parse(File.read(File.join(layer_dir, "json")))
      size = File.read(File.join(layer_dir, "layersize"))
      layer = Layer.new(layer_id, size, data)
      layer.associate_tag(tag) if tag
      @layers[layer_id] = layer
      if data["parent"]
        parent = register_layer(data["parent"])
        layer.parent = parent
      end
      layer
    end

    def layers
      @layers.values
    end

    def layer(layer_id)
      @layers[layer_id]
    end

  end

end

