require "milyoni_magick/utils"

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
