module Inspector

  class Container
    attr_reader :data, :container_id
    attr_accessor :image

    def initialize(container_dir)
      @data         = JSON.parse(File.read(File.join(container_dir, "config.json")))
      @container_id = File.basename(container_dir)
      @tags         = []

      layer = LayerRegistry.instance.layer(@data['Image'])
      if layer
        @tags = layer.tags
      end
    end

    def to_s
      msg = "#{@container_id} created on #{@data['Created']}, Size #{Filesize.from("#{@size} B")}, "
      if @tags.empty?
        msg += "Based on an unknown image\n"
      else
        msg += "Based on image: "
        msg += @tags.map{|t| "#{t.image.name}:#{t.name}"}.join(", ")
        msg += "\n"
      end
    end

  end

end
