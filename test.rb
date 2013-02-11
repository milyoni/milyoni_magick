class Hash
  def to_argv
    self.map { |k, v| "-#{k} #{v}" }.join(" ")
  end
end

# Defaults
template    = "./images/template-quote.png"
image       = "./images/image.jpg"
image_sized = "./images/image_sized.jpg"
image_resize_dimensions = "216x125"
tmp_image_canvas  = "./tmp/card_done.png"
tmp_image_text  = "./tmp/text.png"
body_text_dimensions  = "216x115"
header_text = "Life of PI"
# 180 characters long
body_text   = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ulla"

def font_family
  "./fonts/Helvetica.dfont"
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

def convert(cmd)
  `convert #{cmd}`
end

def composite(cmd)
  `composite #{cmd}`
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
  command = "#{source_file_path} #{options} #{output_file_path}"
  convert(command)
end
add_header_text(template, tmp_image_canvas, header_text)

def create_body_text(text, body_text_dimensions, output_file_path)
  # caption used to create a text image that wraps to fit
  # gravity set north-west to top-left align text
  options = base_font_options.merge({
    :background => "transparent",
    :gravity => "NorthWest",
    :size => body_text_dimensions
  }).to_argv
  command = "#{options} caption:'#{text}' #{output_file_path}"
  convert(command)
end
create_body_text(body_text, body_text_dimensions, tmp_image_text)

def composite_body_text(composite_image_path, canvas_image_path)
  margin_left = 0
  margin_top = 200
  geometry = "+#{margin_left}+#{margin_top}"
  options = {
    :gravity => "North",
    :geometry => geometry
  }.to_argv
  # composite text_file over template copy and re-output to temlate copy
  command = "#{options} #{composite_image_path} #{canvas_image_path} #{canvas_image_path}"
  composite(command)
end
composite_body_text(tmp_image_text, tmp_image_canvas)

# resize the image
def resize_card_image(source_file_path, output_file_path, dimensions)
  options = {
    :resize => dimensions
  }.to_argv
  command = "#{source_file_path} #{options} #{output_file_path}"
  convert(command)
end
resize_card_image(image, image_sized, image_resize_dimensions)

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
  command = "#{options} #{composite_image_path} #{canvas_image_path} #{canvas_image_path}"
  composite(command)
end
composite_card_image(image_sized, tmp_image_canvas)

`open #{tmp_image_canvas}`
