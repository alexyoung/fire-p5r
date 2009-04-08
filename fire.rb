# Fire

# Algorithm:
#   1. Create an indexed palette of red, orange and yellows
#   2. Loop:
#   3.   Draw a random set of colours from the palette at the bottom of the screen
#   4.   Loop through each pixel and average the colour index value around it
#   5.   Reduce the average by a fire intensity factor

# rp5 run fire.rb

class Fire < Processing::App

  def setup
    color_mode RGB, 255
    background 0
    frame_rate 30

    @palette = make_palette
    @fire = []

    @scale = 8
    @width = width / @scale
    @height = height / @scale

    @intensity = 2
  end
  
  def draw
    update_fire
  end

  def update_fire
    random_line @height - 1
    (0..@height - 2).each do |y|
      (0..@width).each do |x|
        # Wrap
        left = (x == 0) ? fire_data(@width - 1, y) : fire_data(x - 1, y)
        right = (x == @width - 1) ? fire_data(0, y) : fire_data(x + 1, y)
        below = fire_data(x, y + 1)

        # Get the average pixel value
        average = (left.to_i + right.to_i + (below.to_i * 2)) / 4

        # Fade the flames
        average -= @intensity if average > @intensity

        set_fire_data x, y, average

        fill color(*@palette[average])
        stroke color(*@palette[average])

        rect x * @scale, (y + 1) * @scale, @scale, @scale
      end
    end
  end

  def fire_data(x, y)
    @fire[offset(x, y)]
  end

  def set_fire_data(x, y, value)
    @fire[offset(x, y)] = value
  end

  def make_palette
    palette = []
    # Create the bands of colour for the palette (256 is the maximum colour)
    limit = 64
    multiplier = 256 / limit
    (0..limit).each do |i|
      # Range of reds
      palette[i] = [i * multiplier, 0, 0]
      # Orange
      palette[i + limit] = [255, i * multiplier, 0]
      # Yellow
      palette[i + limit * 2] = [255, 255, i * multiplier]
      # Also try making this white, I prefer a strong red (in wine terms too)
      palette[i + limit * 3] = [180, 0, 0]
    end
    palette
  end
  
  def random_colour
    color *@palette[rand(@palette.size)]
  end

  def random_offset
    rand @palette.size
  end

  def random_line(y)
    (0..@width - 1).each do |x|
      @fire[offset(x, y)] = random_offset
    end
  end

  def offset(x, y)
    (y * @width) + x
  end
end

Fire.new :title => "Fire", :width => 320, :height => 240
