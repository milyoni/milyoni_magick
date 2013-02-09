def image_path(file)
  `pwd`.chop + "/images/#{file}"
end

def tmp_path(file)
  `pwd`.chop + "/tmp/#{file}"
end
def font_path(file)
  `pwd`.chop + "/fonts/#{file}"
end
template = image_path("template-quote.png")
image = image_path("image.jpg")
image_sized = image_path("chick_sized.jpg")
header_text = "Life of PI"

def font
  font_path("Helvetica.dfont")
end

body_text = "Lorem ipsum dolor sit amet, \nconsectetur adipisicing elit, sed do eiusmod tempor incididunt \nut labore et dolore magna aliqua. \nUt enim ad minim veniam, quis nostrud exercitation ullam"

def font_metrics
  %x"convert xc: -font '#{font}' -pointsize 18 -debug annotate -annotate 0 'Lorem Ipsum' null: 2>&1 | grep Metrics: | fmt -w80"
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

def annotation_options
  "-fill white -gravity South -pointsize 18 -font '#{font}'"
end

# Add the header text
def add_header_text(source_file_path, output_file_path, text)
  `convert #{source_file_path} -density 90 -fill white -gravity North -pointsize 18 -family '#{font}' -style 'normal' -annotate +0+14 '#{text}' #{output_file_path}`
end
add_header_text(template, tmp_path("card_done.png"), header_text)

def add_body_text(source_file_path, output_file_path, text)
  `convert #{source_file_path} -density 90 -fill white  -family '#{font}' -style 'normal' -gravity North-West -annotate +18+200 '#{text}' #{output_file_path}`
end
add_body_text(tmp_path("card_done.png"), tmp_path("card_done.png"), body_text)

# resize the image
def resize(source_file_path, output_file_path, dimensions)
  `convert #{source_file_path} -resize #{dimensions} #{output_file_path}`
end
resize(image, image_sized, "220x125")

# composite image onto template
def composite(source_file_path, composite_file_path, output_file_path)
  `convert -gravity North -geometry +0+52 -composite #{source_file_path} #{composite_file_path}  #{output_file_path}`
end
composite(tmp_path("card_done.png"), image_sized, tmp_path("card_done.png"))

`open #{tmp_path("card_done.png")}`