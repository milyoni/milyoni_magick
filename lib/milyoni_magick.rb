require "tempfile"
require "milyoni_magick/utils"
require "milyoni_magick/image"

module MilyoniMagick
  def convert(cmd)
    silence_stream(STDERR) do
      `convert #{cmd}`
    end
  end

  def composite(cmd)
    silence_stream(STDERR) do
      `composite #{cmd}`
    end
  end

  # silence_stream from active_support/core_ext/kernel to prevent rails requirement
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end
end

class Hash
  def to_argv
    self.map { |k, v| "-#{k} #{v}" }.join(" ")
  end
end
