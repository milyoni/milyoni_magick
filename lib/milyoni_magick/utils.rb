module Utils
  def font_metrics
    %x"convert xc: -font '#{font_family}' -pointsize 18 -debug annotate -annotate 0 'Lorem Ipsum' null: 2>&1 | grep Metrics: | fmt -w80"
  end

  def dimensions(source_file_path)
    `identify -format '%wx%h' #{source_file_path}`
  end

  def width(source_file_path)
    `identify -format '%w' #{source_file_path}`
  end

  def height(source_file_path)
    `identify -format '%h' #{source_file_path}`
  end
end
