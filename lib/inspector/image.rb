
module Inspector

  class Image

    attr_reader :name, :tags

    def initialize(name, tags)
      @name = name
      @tags = []

      tags.each do |tag_name, layer|
        @tags << Tag.new(self, tag_name, layer)
      end
    end

    def tag(tag)
      @tags.find{|t| t.name == tag}
    end

    def has_tag?(tag)
      !self.tag(tag).nil?
    end

    def to_s
      @tags.map do |tag|
        "#{@name}:#{tag.name}"
      end.join("\n")
    end

  end

end
