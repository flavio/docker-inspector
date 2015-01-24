
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
      ret = ""
      @tags.each do |tag|
        ret += "#{@name}:#{tag.name}\n"
      end

      ret
    end

  end

end
