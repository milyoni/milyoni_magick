class Hash
  def to_argv
    self.map { |k, v| "-#{k} #{v}" }.join(" ")
  end
end

# Defaults
template    = "./images/template-quote.png"
image       = "./images/image.jpg"
image_sized = "./images/image_sized.jpg"
header_text = "Life of PI"
# 180 characters long
body_text   = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ulla"

def font_family
  "./fonts/Helvetica.dfont"
end

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

def base_font_options
  {
    :density => 90,
    :fill => "white",
    :family => font_family,
    :style => "normal",
  }
end

def header_font_options
  base_font_options.merge({
    :pointsize => 18
  })
end

# Add the header text
def add_header_text(source_file_path, output_file_path, text)
  margin_left = 0
  margin_top = 14
  geometry = "+#{margin_left}+#{margin_top}"
  options = header_font_options.merge({
    :gravity => "North",
    :annotate => "#{geometry} '#{text}'" # this argument must come last in the list of arguments
  }).to_argv
  `convert #{source_file_path} #{options} #{output_file_path}`
end
add_header_text(template, "./tmp/card_done.png", header_text)

def create_body_text(text, output_file_path)
  # caption used to create a text image that wraps to fit
  # gravity set north-west to top-left align text
  options = base_font_options.merge({
    :background => "transparent",
    :gravity => "NorthWest",
    :size => "216x115"
  }).to_argv
  `convert #{options} caption:'#{text}' #{output_file_path}`
end
create_body_text(body_text, "./tmp/text.png", )

def composite_body_text(composite_image_path, canvas_image_path)
  margin_left = 0
  margin_top = 200
  geometry = "+#{margin_left}+#{margin_top}"
  options = {
    :gravity => "North",
    :geometry => geometry
  }.to_argv
  # composite text_file over template copy and re-output to temlate copy
  `composite #{options} #{composite_image_path} #{canvas_image_path} #{canvas_image_path}`
end
composite_body_text("./tmp/text.png", "./tmp/card_done.png")

# resize the image
def resize_card_image(source_file_path, output_file_path, dimensions)
  options = {
    :resize => dimensions
  }.to_argv
  `convert #{source_file_path} #{options} #{output_file_path}`
end
resize_card_image(image, image_sized, "216x125")

# composite image onto template
def composite_card_image(composite_image_path, canvas_image_path)
  margin_left = 0
  margin_top = 52
  geometry = "+#{margin_left}+#{margin_top}"
  options = {
    :gravity => "North",
    :geometry => geometry
  }.to_argv
  # composite image_file over template copy and re-output to temlate copy
  `composite #{options} #{composite_image_path} #{canvas_image_path} #{canvas_image_path}`
end
composite_card_image(image_sized, "./tmp/card_done.png")

`open ./tmp/card_done.png`
