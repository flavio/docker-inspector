module Inspector
  def self.ensure_root
    if Process.uid != 0
      warn "root user required to access /var/lib/docker"
      exit(1)
    end
  end

  def self.parse_images
    repositories = JSON.parse(File.read(repositories_file))
    images = {}

    if repositories.has_key?("Repositories")
      repositories["Repositories"].each do |image_name, tags|
        image = Image.new(image_name, tags)
        images[image.name] = image
      end
    end

    images
  end

  def self.parse_containers
    containers = {}
    Dir["/var/lib/docker/containers/*"].each do |container_dir|
      container = Container.new(container_dir)
      containers[container.container_id] = container
    end
    containers
  end


  def self.repositories_file
    known_repositories = [
      "/var/lib/docker/repositories-btrfs",
      "/var/lib/docker/repositories-devicemapper"
    ]

    known_repositories.each do |repository|
      return repository if File.exist?(repository)
    end

    raise "Cannot find a known repositories file"
  end

end
