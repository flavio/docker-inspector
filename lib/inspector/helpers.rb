module Inspector

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

  def self.repositories_file
    known_repositories = [
      "/var/lib/docker/repositories-btrfs"
    ]

    known_repositories.each do |repository|
      return repository if File.exist?(repository)
    end

    raise "Cannot find a known repositories file"
  end

end
