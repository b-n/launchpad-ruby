class Display
  
  def initialize(output)
    @output = output
    @positions = [
      [36, 37, 38, 39, 68, 69, 70, 71],
      [40, 41, 42, 43, 72, 73, 74, 75],
      [44, 45, 46, 47, 76, 77, 78, 79],
      [48, 49, 50, 51, 80, 81, 82, 83],
      [52, 53, 54, 55, 84, 85, 86, 87],
      [56, 57, 58, 59, 88, 89, 90, 91],
      [60, 61, 62, 63, 92, 93, 94, 95],
      [64, 65, 66, 67, 96, 97, 98, 99]
    ]

    @note_positions = []
    @positions.each_with_index { |arr, y|
      arr.each_with_index { |note, x|
        @note_positions[note] = [x, y]
      }
    }
    @note_velocities = {}
  end

  def get_position_velocity(x, y)
    get_note_velocity(@positions[y][x])
  end

  def get_note_velocity(note)
    @note_velocities[note] || 0
  end

  def get_note_position(note)
    @note_positions[note] 
  end

  def get_note_at_position(x, y)
    @positions[y][x]
  end

  def reset
    @positions.each { |arr| arr.each { |note| set_note_color(note, 0) } }
  end

  def set_position_color(x, y, velocity)
    set_note_color(
      get_note_at_position(x, y),
      velocity
    )
  end

  def set_note_color(note, velocity)
    @note_velocities[note] = velocity
    @output.puts(MIDIMessage::NoteOn.new(
      0,
      note,
      velocity
    ))
  end

end
