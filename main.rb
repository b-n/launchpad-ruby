#!/usr/bin/env ruby

require './display'
require 'midi-eye'
require 'concurrent'

@input = UniMIDI::Input.use(1)
@output = UniMIDI::Output.use(1)

display = Display.new(@output)
display.reset

transpose = MIDIEye::Listener.new(@input)

transpose.listen_for do |event|
  message = event[:message]
  next unless message.velocity == 127

  x, y = display.get_note_position(message.note)

  for i in 0..7
    display.set_position_color(i, y, 127)
  end

  for i in 0..7
    display.set_position_color(x, i, 126)
  end

  display.set_position_color(x, y, 63)
end

puts "Go!"

transpose.run
