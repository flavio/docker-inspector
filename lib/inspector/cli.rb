module Inspector
  class Details < Thor
    desc "image IMAGE", "Details about IMAGE"
    def image(image_name)
      Inspector.ensure_root()
      images = Inspector.parse_images()

      name, tag = image_name.split(":", 2)
      tag ||= "latest"

      if !images.has_key?(name)
        warn "Cannot find image #{image_name}"
        exit(1)
      end

      image = images[name]
      tag = image.tag(tag)

      if !tag
        warn "Cannot find image #{image_name}"
        exit(1)
      end

      puts "This image is made by #{tag.layers.count} layers:"
      table = Terminal::Table.new do |t|
        t.headings = ["Number", "ID", "Size", "Tags", "Created"]
        tag.layers.each_with_index do |l, index|
          t.add_row([index + 1 ] + l.to_row)
        end
      end
      puts table
    end

    desc "container CONTAINER_ID", "Details about a container"
    def container(container_id)
      Inspector.ensure_root()

      containers = Inspector.parse_images
      containers = Inspector.parse_containers
      container = containers[container_id]
      if !container
        warn "Cannot find container #{container_id}"
        exit(1)
      end

      puts container
      puts JSON.pretty_generate(container.data)
    end

  end

  # This is the public facing command line interface which is available through
  # the +dister+ command line tool. Use +dister --help+ for usage instructions.
  class Cli < Thor
    # include Thor::Actions

    desc "version", "Show dister version"
    def version
      puts Inspector::VERSION
    end

    desc "images", "List the available images"
    def images
      Inspector.ensure_root()
      images = Inspector.parse_images()
      images.values.each do |image|
        puts image
      end
    end

    desc "details SUBCOMMAND ...ARGS", "Provide more details"
    subcommand "details", Details


    desc "layers", "List all the available layers"
    def layers
      Inspector.ensure_root()
      Inspector.parse_images()

      table = Terminal::Table.new do |t|
        t.headings = ["ID", "Size", "Tags", "Created"]
        LayerRegistry.instance.layers.each do |l|
            t.add_row(l.to_row)
        end
      end
      puts table
    end

    desc "dot [IMAGE...]", "Create dot graph for the image specified or for all the images if no name is provided"
    def dot(*image_names)
      Inspector.ensure_root()
      images = Inspector.parse_images()
      tags_to_process = []

      if image_names.empty?
        tags_to_process = images.values.map{|i| i.tags}.flatten
      else
        image_names.each do |image_name|
          name, tag_name = image_name.split(":", 2)
          tag_name ||= "latest"

          image = images[name]
          if image.nil?
            warn "Cannot find #{image_name}"
            exit(1)
          end

          tag = image.tag(tag_name)
          if tag.nil?
            warn "Cannot find #{tag_name} for image #{name}"
            exit(1)
          end
          tags_to_process << tag
        end
      end

      tag_labels = Hash.new {|h,k| h[k] = Set.new()}
      relations = Set.new()
      output_file = "docker_inspector.png"
      tmpfile = Tempfile.new("docker_inspector")
      tmpfile << "digraph {\n"

      tags_to_process.each do |tag|
        layers = tag.layers

        # write node relations
        relations << layers.map{|l| "\"#{l.short_id}\""}.join(" -> ") + "\n"

        # write labels for tagged layers
        layers.reject{|l| l.tags.empty?}.each do |tl|
          tl.tags.each do |tag|
            tag_labels[tl.short_id] << {
              :image_name => tag.image.name,
              :tag_name   => tag.name
            }
          end
        end
      end

      relations.each {|r| tmpfile << r}

      tag_labels.each do |tag_id, labels|
        tmpfile << "\"#{tag_id}\"[label=<#{tag_id}<BR />\n"
        tmpfile << labels.map do |data|
          "<FONT POINT-SIZE=\"10\">#{data[:image_name]}:#{data[:tag_name]}</FONT>"
        end.join("<BR />\n")
        tmpfile << ">];\n"
      end

      tmpfile << "\n}\n"
      tmpfile.close()

      begin
        `dot #{tmpfile.path} -Tpng -o #{Shellwords::shellescape(output_file)}`
        if $? == 0
          puts "#{output_file} generated"
        else
          warn "Something went wrong"
          exit(1)
        end
      rescue Errno::ENOENT => e
        warn "Error: #{e.message}"
        exit(1)
      ensure
        tmpfile.unlink
      end
    end

    desc "containers", "List all the available containers"
    def containers
      # Required to load details about layers and images
      Inspector.parse_images

      table = Terminal::Table.new do |t|
        t.headings = ["ID", "Created", "Size", "Based on"]
        Inspector.parse_containers.values.each do |container|
          t.add_row(container.to_row)
        end
      end
      puts table

    end

  end

end
