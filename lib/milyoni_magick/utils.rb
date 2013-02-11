module Utils
  def font_metrics
    @font_metrics ||= `convert xc: -font '#{font_family}' -pointsize 18 -debug annotate -annotate 0 'Lorem Ipsum' null: 2>&1 | grep Metrics: | fmt -w80`
  end

  def dimensions
    @dimensions ||= `identify -format '%wx%h' #{source_file_path}`.chomp
  end

  def width
    @width ||= `identify -format '%w' #{source_file_path}`.chomp.to_i
  end

  def height
    @height ||= `identify -format '%h' #{source_file_path}`.chomp.to_i
  end
end
