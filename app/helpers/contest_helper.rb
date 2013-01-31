module ContestHelper
  def work_image_tag work, max_width = 965
    source_width, source_height = work.image_url.match(/\d+-\d+/)[0].split('-')
    image_width = source_width.to_i
    image_height = source_height.to_i
    if image_width > max_width
      image_width = max_width
      image_height = (max_width * source_height.to_i / source_width.to_i).to_i
    end

    image_tag work.image_url.gsub(/\d+-\d+/, "#{image_width}-#{image_height}!"), :size => "#{image_width}x#{image_height}", :alt => "#{work.author_info}. #{work.title}"
  end
end
