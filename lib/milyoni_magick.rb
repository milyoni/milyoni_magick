require "tempfile"
require "milyoni_magick/utils"
require "milyoni_magick/image"

module MilyoniMagick
  def convert(cmd)
    `convert #{cmd}`
  end

  def composite(cmd)
    `composite #{cmd}`
  end
end

class Hash
  def to_argv
    self.map { |k, v| "-#{k} #{v}" }.join(" ")
  end
end
