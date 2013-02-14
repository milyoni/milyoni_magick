module MilyoniMagick
  class Image
    include MilyoniMagick

    attr_reader :source_file_path, :tempfile

    def self.read(source)
      new(source)
    end

    def write(output)
      `mv #{tempfile.path} #{output}`
    end

    def write_and_open(output)
      write(output)
      `open #{output}`
    end

    def initialize(file_path_or_image)
      if file_path_or_image.is_a?(MilyoniMagick::Image)
        @source_file_path = file_path_or_image.path
      else
        @source_file_path = file_path_or_image
      end
      @tempfile = new_temp_file(@source_file_path)
    end

    def annotate(text, opts = {})
      left = opts.delete(:left)
      top = opts.delete(:top)

      geometry = (left && top) ? "+#{left}+#{top}" : 0

      options = header_font_options.merge({
        :gravity => "North",
        :annotate => "#{geometry} \"#{text.gsub(/[\"]/, '\"')}\"" # this argument must come last in the list of arguments
      }).to_argv
      command = "#{tempfile.path} #{options} #{tempfile.path}"
      #puts command
      convert(command)
    end

    def composite!(image, opts = {})
      left = opts.delete(:left)
      top = opts.delete(:top)

      geometry = "+#{left}+#{top}"

      options = {
        :gravity => "North",
        :geometry => geometry
      }.to_argv

      # composite image_file over template copy and re-output to temlate copy
      command = "#{options} #{image.path} #{tempfile.path} #{tempfile.path}"
      composite(command)
    end

    def caption(text, opts = {})
      left = opts.delete(:left)
      top = opts.delete(:top)
      size = opts.delete(:size)
      pointsize = opts.delete(:pointsize)

      # generate a temporary image file with caption text
      caption_img = new_temp_file
      options = base_font_options.merge({
        :background => "transparent",
        :gravity => "NorthWest",
        :size => size,
        :pointsize => pointsize
      }).to_argv

      command = "#{options} caption:\"#{text.gsub(/[\"]/, '\"')}\" #{caption_img.path}"
      convert(command)

      # composite caption text image onto self
      geometry = "+#{left}+#{top}"
      options = {
        :gravity => "North",
        :geometry => geometry
      }.to_argv

      # composite text_file over template copy and re-output to temlate copy
      command = "#{options} #{caption_img.path} #{tempfile.path} #{tempfile.path}"
      composite(command)
    end

    def resize!(size)
        options = {
          :resize => size
        }.to_argv
        command = "#{tempfile.path} #{options} #{tempfile.path}"
        convert(command)
    end

    # TODO: extract defaults
    def font_family
      "./fonts/Helvetica.dfont"
    end

    # TODO: extract defaults
    def header_font_options
      base_font_options.merge({
        :pointsize => 18
      })
    end

    # TODO: extract defaults
    def base_font_options
      {
        :density => 90,
        :fill => "white",
        :family => font_family,
        :style => "normal",
      }
    end

    def path
      tempfile.path
    end

    private
    def new_temp_file(file_path = nil)
      tmp = Tempfile.new(['tmp', '.png'])
      tmp << File.read(file_path) if file_path
      tmp.close
      tmp
    end
  end
end