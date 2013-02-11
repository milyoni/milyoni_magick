require "./lib/milyoni_magick"

include MilyoniMagick

# Defaults
body_text_length = 140
body_text   = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ulla"[0..body_text_length]
header_text_length = 18
header_text = "Life of PI Foo Bar"[0..header_text_length]

image = MilyoniMagick::Image.read("./images/template-quote.png")
image.annotate(header_text, {
  :pointsize => 18,
  :left => 0,
  :top => 14,
})
image.caption(body_text, {
  pointsize: 10,
  left: 0,
  top: 200,
  size: "216x115"
})

image3 = MilyoniMagick::Image.read("./images/image_sized.jpg")
image.composite!(image3, {
  left: 0,
  top: 52
})

image.write_and_open("output_file.png")

## resize the image
#def resize_card_image(source_file_path, output_file_path, dimensions)
#  options = {
#    :resize => dimensions
#  }.to_argv
#  command = "#{source_file_path} #{options} #{output_file_path}"
#  convert(command)
#end
#resize_card_image(card_image, card_image_sized, image_resize_dimensions)